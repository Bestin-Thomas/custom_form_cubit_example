
import 'package:flutter/material.dart';

import 'form_field_controller.dart';

class ReactiveFormField extends StatefulWidget {
  final FormControl<String> control;
  final ValueSetter<String>? onChange;
  final String label;
  final String hint;
  final TextInputType? keyboardType;

  const ReactiveFormField({
    super.key,
    required this.control,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.onChange,
  });

  @override
  State<ReactiveFormField> createState() => _ReactiveFormFieldState();
}

class _ReactiveFormFieldState extends State<ReactiveFormField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.control.value);

    widget.control.valueChanges.listen((value) {
      if (_controller.text != value) {
        _controller.text = value ?? '';
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: widget.control.valueChanges,
      builder: (context, _) {
        return TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            errorText: widget.control.error,
            border: const OutlineInputBorder(),
          ),
          keyboardType: widget.keyboardType,
          onChanged: (value) {
            widget.control.setValue(value);
            widget.onChange?.call(value);
          },
        );
      },
    );
  }
}
