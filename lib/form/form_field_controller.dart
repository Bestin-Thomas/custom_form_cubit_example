import 'dart:async';
import 'package:flutter/material.dart';

/// Represents a form error, which contains an error message.
class FormError {
  /// The error message associated with the form control.
  final String message;

  /// Creates a [FormError] with the given error message.
  FormError(this.message);
}

/// Represents the status of a form control, indicating its state.
///
/// - [pristine]: The control has not been interacted with.
/// - [dirty]: The control's value has been changed.
/// - [valid]: The control's value passes all validations.
/// - [invalid]: The control's value fails at least one validation.
enum GenericFieldStatus { pristine, dirty, valid, invalid }

/// A form control that manages the value, validation, and state of a field.
///
/// [T] is the type of the value managed by the control.
class GenericFieldController<T> {
  /// The internal value notifier for the form control.
  final ValueNotifier<T?> _valueNotifier;

  /// A list of validator functions that validate the control's value.
  final List<FormError? Function(T? value)> _validators;

  /// The current error of the form control, if any.
  FormError? _error;

  /// The current status of the form control.
  GenericFieldStatus _status = GenericFieldStatus.pristine;

  /// A stream controller that broadcasts value changes.
  final _valueChangesController = StreamController<T?>.broadcast();

  /// Creates a [GenericFieldController] with an initial value and optional validators.
  ///
  /// - [initialValue]: The initial value of the form control.
  /// - [validators]: A list of validation functions for the control.
  GenericFieldController(
    T? initialValue, {
    List<FormError? Function(T? value)>? validators,
  })  : _valueNotifier = ValueNotifier<T?>(initialValue),
        _validators = validators ?? [] {
    // Listen to value changes and validate the control.
    _valueNotifier.addListener(() {
      _valueChangesController.add(_valueNotifier.value);
      _validate();
    });
  }

  /// Adds additional validations to the form control.
  ///
  /// - [validation]: A list of validation functions to be added.
  void addValidations(List<FormError? Function(T?)> validation) =>
      _validators.addAll(validation);

  /// Sets a new value for the form control and marks it as dirty.
  ///
  /// - [newValue]: The new value to be set.
  void setValue(T? newValue) {
    if (_valueNotifier.value != newValue) {
      _valueNotifier.value = newValue;
      _status = GenericFieldStatus.dirty;
    }
  }

  /// Validates the form control and updates its error and status.
  void _validate() {
    _error = null;
    for (final validator in _validators) {
      _error = validator(_valueNotifier.value);
      if (_error != null) {
        _status = GenericFieldStatus.invalid;
        break;
      }
    }
    if (_error == null) {
      _status = GenericFieldStatus.valid;
    }
  }

  /// Resets the form control to its initial state.
  void reset() {
    _valueNotifier.value = null;
    _error = null;
    _status = GenericFieldStatus.pristine;
  }

  /// Indicates whether the form control is valid.
  bool get isValid {
    _validate();
    return _status == GenericFieldStatus.valid;
  }

  /// Indicates whether the form control is dirty.
  bool get isDirty {
    _validate();
    return _status == GenericFieldStatus.dirty;
  }

  /// The current error of the form control, if any.
  FormError? get error => _error;

  /// The current value of the form control.
  T? get value => _valueNotifier.value;

  /// The notifier for the control's value, allowing reactive updates.
  ValueNotifier<T?> get notifier => _valueNotifier;

  /// A stream that emits value changes for the control.
  Stream<T?> get valueChanges => _valueChangesController.stream;

  /// Disposes of the control, releasing resources.
  void dispose() {
    _valueChangesController.close();
    _valueNotifier.dispose();
  }
}

/// Represents a base class for a form model containing multiple form controls.
abstract class GenericFormModel {
  /// A list of all form controls in the form.
  List<GenericFieldController> get controls;

  /// Validates all form controls in the form.
  ///
  /// Returns `true` if all controls are valid.
  bool validate() => controls.every((control) => control.isValid);

  /// Resets all form controls to their initial state.
  void reset() {
    for (final control in controls) {
      control.reset();
    }
  }

  /// Indicates whether all form controls are valid.
  bool get isValid => controls.every((control) => control.isValid);

  /// Indicates whether any control in the form is dirty.
  bool get isDirty => controls.any((control) => control.isDirty);

  /// Disposes of all form controls in the form.
  void dispose() {
    for (final control in controls) {
      control.dispose();
    }
  }
}

/// A reactive form controller that manages a form model and listens for changes.
///
/// [T] is the type of the form model that extends [GenericFormModel].
class GenericFormController<T extends GenericFormModel> {
  /// The form model managed by the reactive form.
  final T model;

  /// A stream controller that broadcasts validity changes.
  final _validityController = StreamController<bool>.broadcast();

  /// Creates a [GenericFormController] with the given form model.
  GenericFormController(this.model) {
    // Listen to value changes for all controls and update validity.
    for (final control in model.controls) {
      control.valueChanges.listen((_) {
        _validityController.add(isValid);
      });
    }
  }

  /// A stream that emits the overall validity of the form whenever it changes.
  Stream<bool> get validityChanges => _validityController.stream;

  /// Indicates whether the entire form is valid.
  bool get isValid => model.isValid;

  /// Indicates whether any control in the form is dirty.
  bool get isDirty => model.isDirty;

  /// Resets all form controls in the form to their initial state.
  void reset() => model.reset();

  /// Disposes of the form and its controls.
  void dispose() {
    model.dispose();
    _validityController.close();
  }
}

