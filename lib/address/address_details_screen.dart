import 'package:custom_form_cubit_example/address/application/address_details_cubit.dart';
import 'package:custom_form_cubit_example/address/application/address_details_state.dart';
import 'package:custom_form_cubit_example/form/reactive_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../form/form_text_field.dart';

class AddressDetailsScreen extends StatelessWidget {
  const AddressDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (_) => AddressDetailsCubit(),
          child: AddressForm(),
        ),
      ),
    );
  }
}

class AddressForm extends StatelessWidget {
  const AddressForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: BlocSelector<AddressDetailsCubit, AddressDetailsState, AddressDetailsFormModel>(
          selector: (state) => state.formModel,
          builder: (context, model) => ReactiveFormBuilder<AddressDetailsFormModel>(
              form: model,
              onChange: (formModel) => context.read<AddressDetailsCubit>().updateForm(formModel),
              builder: (context, form, onSubmit) => Column(
                spacing: 10,
                children: [
                  ReactiveFormField(
                    control: form.houseName,
                    label: 'House Name',
                    hint: 'Enter your house name',
                  ),
                  ReactiveFormField(
                    control: form.city,
                    label: 'City',
                    hint: 'Enter your city',
                  ),
                  ReactiveFormField(
                    control: form.district,
                    label: 'District',
                    hint: 'Enter your district',
                  ),
                  ReactiveFormField(
                    control: form.state,
                    label: 'State',
                    hint: 'Enter your state',
                  ),
                  ReactiveFormField(
                    control: form.country,
                    label: 'Country',
                    hint: 'Enter your country',
                  ),
                  ReactiveFormField(
                    control: form.pinCode,
                    label: 'Post Code',
                    hint: 'Enter your post code',
                  ),
                ],
              ),
            )),
    );
  }
}
