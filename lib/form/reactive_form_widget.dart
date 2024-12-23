
import 'package:flutter/material.dart';

import 'form_field_controller.dart';

class ReactiveFormWidget<T extends FormModel> extends StatefulWidget {
  final ReactiveForm form;
  final Widget child;
  const ReactiveFormWidget(
      {super.key, required this.form, required this.child});

  @override
  State<ReactiveFormWidget> createState() => _ReactiveFormWidgetState();
}

class _ReactiveFormWidgetState extends State<ReactiveFormWidget> {
  late ReactiveForm _form;

  @override
  void initState() {
    super.initState();
    // Listen to form validity changes
    _form = widget.form;
    _form.validityChanges.listen((isValid) {
      setState(() {}); // Rebuild to update submit button state
    });
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
