import '../form/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../address/address_details_screen.dart';
import '../form/form_text_field.dart';
import '../form/reactive_form_builder.dart';
import 'application/login_cubit.dart';
import 'application/login_form_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => RegistrationFormCubit(),
        child: ContactFormScreen(),
      ),
    );
  }
}

class ContactFormScreen extends StatelessWidget {
  const ContactFormScreen({super.key});

  void _handleSubmit({
    required BuildContext context,
    required GenericFormController<RegistrationFormModel> formController,
  }) {
    formController.isValid;
    context.read<RegistrationFormCubit>().submit(
      validAction: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form submitted successfully!')),
        );

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddressDetailsScreen()),
        );
      },
    );
  }

  void _handleCubit({
    required BuildContext context,
    required RegistrationFormModel model,
  }) =>
      context.read<RegistrationFormCubit>().updateForm(model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocSelector<RegistrationFormCubit, RegistrationFormState, RegistrationFormModel>(
            selector: (state) => state.formModel,
            builder: (context, model) {
              final formController =  GenericFormController(model);
              return ReactiveFormBuilder<RegistrationFormModel>(
                  form: formController,
                  onChange: (formModel) => _handleCubit(context: context, model: formModel),
                  builder: (context, loginFormModel) => Column(
                    children: [
                      ReactiveFormField(
                        control: loginFormModel.name,
                        label: 'Name',
                        hint: 'Enter your full name',
                      ),
                      const SizedBox(height: 16),
                      ReactiveFormField(
                        control: loginFormModel.email,
                        label: 'Email',
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      ReactiveFormField(
                        control: loginFormModel.phone,
                        label: 'Phone',
                        hint: 'Enter your phone number',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),
                      BlocSelector<RegistrationFormCubit, RegistrationFormState, bool>(
                          selector: (state) => state.isLoading,
                          builder: (context, isLoading) => ElevatedButton(
                                onPressed: () => _handleSubmit(context: context, formController: formController),
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: isLoading ? Colors.red : Colors.blue),
                                ),
                              )),
                    ],
                  ),
                );
            }),
      ),
    );
  }
}
