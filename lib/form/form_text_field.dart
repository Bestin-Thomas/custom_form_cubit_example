import 'package:flutter/material.dart';

import 'form_field_controller.dart';

class ReactiveFormField extends StatelessWidget {
  final GenericFieldController<String> control;
  final ValueSetter<String>? onChange;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final bool autofocus;

  const ReactiveFormField({
    super.key,
    required this.control,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.onChange,
    this.textInputAction = TextInputAction.next,
    this.autofocus = true,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>( 
      valueListenable: control.notifier,
      builder: (context, value, child) {
        return TextFormField(
          initialValue: value,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            errorText: control.error?.message,
            border: const OutlineInputBorder(),
          ),
          autofocus: autofocus,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          onChanged: (newValue) {
            control.setValue(newValue);
            onChange?.call(newValue);
          },
        );
      },
    );
  }
}
