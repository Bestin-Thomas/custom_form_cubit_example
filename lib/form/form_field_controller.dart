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
  final List<String? Function(T? value)> _validators;

  /// The current error of the form control, if any.
  final ValueNotifier<String?> _error = ValueNotifier(null);

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
    List<String? Function(T? value)>? validators,
  })  : _valueNotifier = ValueNotifier<T?>(initialValue),
        _validators = validators ?? [] {
    // Listen to value changes and validate the control.
    _valueNotifier.addListener(() {
      _valueChangesController.add(_valueNotifier.value);
      validate();
    });
  }

  /// Adds additional validations to the form control.
  ///
  /// - [validation]: A list of validation functions to be added.
  void addValidations(List<String? Function(T?)> validation) =>
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
  void validate() {
    _error.value = null;
    for (final validator in _validators) {
      _error.value = validator(_valueNotifier.value);
      if (_error.value != null) {
        _status = GenericFieldStatus.invalid;
        break;
      }
    }
    if (_error.value == null) {
      _status = GenericFieldStatus.valid;
    }
  }

  /// Resets the form control to its initial state.
  void reset() {
    _valueNotifier.value = null;
    _error.value = null;
    _status = GenericFieldStatus.pristine;
  }

  /// Indicates whether the form control is valid.
  bool get isValid {
    validate();
    return _status == GenericFieldStatus.valid;
  }

  /// Indicates whether the form control is dirty.
  bool get isDirty {
    validate();
    return _status == GenericFieldStatus.dirty;
  }

  /// The current error of the form control, if any.
  ValueNotifier<String?> get error => _error;

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
  void validate() {
    for (final controller in controls){
      controller.validate();
    }
  }

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
