import 'dart:async';

enum FormFieldControllerStatus { pure, dirty }

/// Represents a single form control that holds a value, validation logic, and a stream to listen for changes.
class FormControl<T> {
  T? _value;
  final List<String? Function(T? value)> _validators;
  String? _error;
  FormFieldControllerStatus _status = FormFieldControllerStatus.pure;
  
  // StreamController for value changes
  final _valueController = StreamController<T?>.broadcast();
  final _statusController = StreamController<FormFieldControllerStatus>.broadcast();

  /// Gets the current value of the form control.
  T? get value => _value;

  /// A stream that emits the value of the form control whenever it changes.
  Stream<T?> get valueChanges => _valueController.stream;

  /// A stream that emits the status whenever it changes.
  Stream<FormFieldControllerStatus> get statusChanges => _statusController.stream;

  /// Gets the current validation error message, if any.
  String? get error => _error;

  /// Gets the current status of the form control.
  FormFieldControllerStatus get status => _status;

  /// Indicates whether the form control is valid (no validation errors).
  bool get isValid => _error == null;

  /// Creates a new form control with an optional initial value and a list of validators.
  ///
  /// - [initialValue]: The initial value of the control.
  /// - [validators]: A list of functions that validate the value and return error messages if invalid.
  FormControl(T? initialValue, {List<String? Function(T? value)> validators = const []})
      : _value = initialValue,
        _validators = validators {
    validate(); // Validate initial value
  }

  /// Updates the value of the form control and triggers validation.
  ///
  /// - [newValue]: The new value to set.
  void setValue(T? newValue) {
    if (_value != newValue) {
      _value = newValue;
      _status = FormFieldControllerStatus.dirty;
      _statusController.add(_status);
      _valueController.add(_value);
      validate();
    }
  }

  /// Marks the control as touched without changing its value.
  void markAsDirty() {
    if (_status != FormFieldControllerStatus.dirty) {
      _status = FormFieldControllerStatus.dirty;
      _statusController.add(_status);
    }
  }

  /// Resets the control to its initial state.
  void reset([T? value]) {
    _value = value;
    _error = null;
    _status = FormFieldControllerStatus.pure;
    _statusController.add(_status);
    _valueController.add(_value);
    validate();
  }

  /// Validates the form control using its validators.
  ///
  /// Returns `true` if the value is valid, otherwise `false`.
  bool validate() {
    for (final validator in _validators) {
      final error = validator(_value);
      if (error != null && error.isNotEmpty) {
        _error = error;
        return false;
      }
    }
    _error = null;
    return true;
  }

  /// Disposes of the stream controllers.
  void dispose() {
    _valueController.close();
    _statusController.close();
  }
}

/// Represents a base class for a form model containing multiple form controls.
abstract class FormModel {
  /// A list of all form controls in the form.
  List<FormControl> get controls;

  /// Validates all form controls in the form.
  ///
  /// Returns `true` if all controls are valid, otherwise `false`.
  bool validate() => controls.every((control) => control.validate());

  /// Resets all form controls to their initial state.
  void reset() {
    for (final control in controls) {
      control.reset();
    }
  }

  /// Indicates whether all form controls are valid.
  bool get isValid => controls.every((control) => control.isValid);

  /// Indicates whether any control in the form is dirty.
  bool get isDirty => controls.any((control) => control.status == FormFieldControllerStatus.dirty);

  /// Disposes of all form controls.
  void dispose() {
    for (final control in controls) {
      control.dispose();
    }
  }
}

/// A reactive form controller that manages a form model and listens for changes.
class ReactiveForm<T extends FormModel> {
  final T model;
  final _validityController = StreamController<bool>.broadcast();

  /// Creates a new reactive form for the given model.
  ///
  /// - [model]: The form model to manage.
  ReactiveForm(this.model) {
    // Listen to all controls for changes and emit validity updates
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