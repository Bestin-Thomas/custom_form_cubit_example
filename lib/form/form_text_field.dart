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
      builder: (context, value, _) {
        return ValueListenableBuilder(
            valueListenable: control.error,
            builder: (context, error, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  TextFormField(
                    initialValue: value,
                    decoration: InputDecoration(
                      labelText: label,
                      hintText: hint,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: error != null ? Colors.red : Colors.green),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: error != null ? Colors.red : Colors.black),
                      ),
                    ),
                    autofocus: autofocus,
                    textInputAction: textInputAction,
                    keyboardType: keyboardType,
                    onChanged: (newValue) {
                      control.setValue(newValue);
                      onChange?.call(newValue);
                    },
                  ),
                  if (error != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Text(
                        error,
                        style: TextStyle( color: Colors.red),
                      ),
                    ),
                ],
              );
            });
      },
    );
  }
}
