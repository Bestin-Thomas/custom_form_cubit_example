import 'dart:async';

import 'package:flutter/material.dart';
import 'form_field_controller.dart';


/// A reactive form controller that manages a form model and listens for changes.
///
/// [T] is the type of the form model that extends [GenericFormModel].
class _GenericFormController<T extends GenericFormModel> {
  /// The form model managed by the reactive form.
  final T model;

  /// A stream controller that broadcasts validity changes.
  final _validityController = StreamController<bool>.broadcast();

  /// Creates a [_GenericFormController] with the given form model.
  _GenericFormController(this.model) {
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

  void validate() => model.validate();

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


/// A widget that provides a reactive form to its child widget, enabling form state management and validation.
///
/// [T] is the type of the form model that extends [GenericFormModel].
class ReactiveFormBuilder<T extends GenericFormModel> extends StatefulWidget {
  /// The reactive form that manages the form state and validation.
  final T form;
  final void Function(T formModel) onChange;
  /// A builder function that builds the child widget tree, providing the current form model.
  final Widget Function(BuildContext context, T form, VoidCallback onSubmit) builder;

  /// Creates a [ReactiveFormBuilder].
  ///
  /// - [form]: The reactive form instance.
  /// - [builder]: A function that builds the widget tree, given the [BuildContext] and the form model.
  const ReactiveFormBuilder({
    super.key,
    required this.form,
    required this.builder,
    required this.onChange,
  });

  @override
  State<ReactiveFormBuilder<T>> createState() => _ReactiveFormBuilderState<T>();
}

/// The state class for [ReactiveFormBuilder].
///
/// Manages the lifecycle of the reactive form and listens for validity changes to rebuild the widget tree.
class _ReactiveFormBuilderState<T extends GenericFormModel> extends State<ReactiveFormBuilder<T>> {
  /// The reactive form instance provided by the widget.
  late _GenericFormController<T> _form;

  @override
  void initState() {
    super.initState();
    _form = _GenericFormController(widget.form);

    // Listen for form validity changes and rebuild the widget tree when the validity changes.
    _form.validityChanges.listen((isValid) {
      widget.onChange.call(_form.model);
      setState(() {}); // Trigger a rebuild to reflect the updated form state.
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build the widget tree using the provided builder function and the form model.
    return widget.builder(context, _form.model, () => _form.validate.call());
  }
}
typedef MyBuilder = void Function(BuildContext context, void Function() methodFromChild);
