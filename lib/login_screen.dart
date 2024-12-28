import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/login_cubit.dart';
import 'application/login_form_state.dart';
import 'form/form_field_controller.dart';
import 'form/form_text_field.dart';
import 'form/reactive_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginFormCubit(),
        child: ContactFormScreen(),
      ),
    );
  }
}

class ContactFormScreen extends StatelessWidget {
  const ContactFormScreen({super.key});

  void _handleSubmit({
    required BuildContext context,
    required ReactiveForm<LoginFormModel> form,
  }) {
    if (form.isValid) {
      // Here you would typically send the data to your backend
      final formData = (form.model).toString();

      log('Form submitted with data: $formData');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
      _handleCubit(
        context: context,
        form: form,
      );
    }
  }

  void _handleCubit({
    required BuildContext context,
    required ReactiveForm<LoginFormModel> form,
  }) =>
      context.read<LoginFormCubit>().updateValues(
            loginForm: form.model,
          );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocSelector<LoginFormCubit, LoginFormState, LoginFormModel>(
            selector: (state) => state.loginForm,
            builder: (context, form) {
              final ReactiveForm<LoginFormModel> formControl = ReactiveForm(form);
              return ReactiveFormWidget<LoginFormModel>(
                form: formControl,
                builder: (context, loginFormModel) => Column(
                    children: [
                      ReactiveFormField(
                        control: loginFormModel.name,
                        onChange: (value) => _handleCubit(
                          context: context,
                          form: formControl,
                        ),
                        label: 'Name',
                        hint: 'Enter your full name',
                      ),
                      const SizedBox(height: 16),
                      ReactiveFormField(
                        control: loginFormModel.email,
                        onChange: (value) => _handleCubit(
                          context: context,
                          form: formControl,
                        ),
                        label: 'Email',
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      ReactiveFormField(
                        control: loginFormModel.phone,
                        onChange: (value) => _handleCubit(
                          context: context,
                          form: formControl,
                        ),
                        label: 'Phone',
                        hint: 'Enter your phone number',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _handleSubmit(
                          context: context,
                          form: formControl,
                        ),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
              );
            }),
      ),
    );
  }
}
