import 'package:flutter/material.dart';
import 'form_field_controller.dart';

/// A widget that provides a reactive form to its child widget, enabling form state management and validation.
///
/// [T] is the type of the form model that extends [FormModel].
class ReactiveFormWidget<T extends FormModel> extends StatefulWidget {
  /// The reactive form that manages the form state and validation.
  final ReactiveForm<T> form;

  /// A builder function that builds the child widget tree, providing the current form model.
  final Widget Function(BuildContext context, T form) builder;

  /// Creates a [ReactiveFormWidget].
  ///
  /// - [form]: The reactive form instance.
  /// - [builder]: A function that builds the widget tree, given the [BuildContext] and the form model.
  const ReactiveFormWidget({
    super.key,
    required this.form,
    required this.builder,
  });

  @override
  State<ReactiveFormWidget<T>> createState() => _ReactiveFormWidgetState<T>();
}

/// The state class for [ReactiveFormWidget].
///
/// Manages the lifecycle of the reactive form and listens for validity changes to rebuild the widget tree.
class _ReactiveFormWidgetState<T extends FormModel>
    extends State<ReactiveFormWidget<T>> {
  /// The reactive form instance provided by the widget.
  late ReactiveForm<T> _form;

  @override
  void initState() {
    super.initState();
    _form = widget.form;

    // Listen for form validity changes and rebuild the widget tree when the validity changes.
    _form.validityChanges.listen((isValid) {
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
