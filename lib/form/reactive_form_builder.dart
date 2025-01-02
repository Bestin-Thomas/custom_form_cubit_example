import 'package:flutter/material.dart';
import 'form_field_controller.dart';

/// A widget that provides a reactive form to its child widget, enabling form state management and validation.
///
/// [T] is the type of the form model that extends [GenericFormModel].
class ReactiveFormBuilder<T extends GenericFormModel> extends StatefulWidget {
  /// The reactive form that manages the form state and validation.
  final GenericFormController<T> form;
  final void Function(T formModel) onChange;

  /// A builder function that builds the child widget tree, providing the current form model.
  final Widget Function(BuildContext context, T form) builder;

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
class _ReactiveFormBuilderState<T extends GenericFormModel>
    extends State<ReactiveFormBuilder<T>> {
  /// The reactive form instance provided by the widget.
  late GenericFormController<T> _form;

  @override
  void initState() {
    super.initState();
    _form = widget.form;

    // Listen for form validity changes and rebuild the widget tree when the validity changes.
    _form.validityChanges.listen((isValid) {
      widget.onChange.call(_form.model);
      setState(() {}); // Trigger a rebuild to reflect the updated form state.
    });
  }

  @override
  void dispose() {
    // Dispose of the reactive form to release resources.
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build the widget tree using the provided builder function and the form model.
    return widget.builder(context, _form.model);
  }
}
