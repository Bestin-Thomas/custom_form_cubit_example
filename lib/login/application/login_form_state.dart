import 'package:freezed_annotation/freezed_annotation.dart';

import '../../form/application/generic_form_cubit.dart';
import '../../form/form_field_controller.dart';

part 'login_form_state.freezed.dart';

@freezed
class RegistrationFormState with _$RegistrationFormState implements GenericFormState<RegistrationFormModel> {
  factory RegistrationFormState({
    required RegistrationFormModel formModel, // Add formModel to the constructor
    @Default(false) bool isLoading,
  }) = _RegistrationFormState;
}

class RegistrationFormModel extends GenericFormModel {
  final name = GenericFieldController<String>(
    null,
    validators: [
      (value) => FormValidators.required(value, field: 'Name'),
      (value) => FormValidators.length(value, fieldName: 'Name', minLength: 3),
    ],
  );

  final email = GenericFieldController<String>(
    null,
    validators: [
      FormValidators.required,
      FormValidators.validateEmail,
    ],
  );

  final phone = GenericFieldController<String>(
    null,
    validators: [
      FormValidators.required,
      (value) => FormValidators.validatePhone(value ?? ''),
      (value) => FormValidators.length(
            value,
            fieldName: 'Phone',
            maxLength: 15,
            minLength: 8,
          ),
    ],
  );

  @override
  List<GenericFieldController> get controls => [name, email, phone];

  RegistrationFormModel() {
    email.addValidations([ (value) {
      FormValidators.custom(condition: true, message: '');
    }]);
  }

  String? _validateEmailDependsOnName(String? value) {
    if (name.value?.isEmpty ?? true) {
      return 'Name is required for email';
    }
    return null;
  }
}

class FormValidators {
  static String? required(
    String? value, {
    String field = 'This Field',
  }) {
    if (value == null || value.isEmpty) {
      return '$field is required';
    }
    return null;
  }

  static String? length(
    String? value, {
    int? minLength,
    int? maxLength,
    required String fieldName,
  }) {
    final valueLength = value?.length ?? 0;
    if (maxLength != null && valueLength > maxLength) {
      return '$fieldName should be less than $maxLength';
    } else if (minLength != null && valueLength < minLength) {
      return '$fieldName should be greater than $minLength';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zAZ0-9]+').hasMatch(value ?? '')) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (!RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(value ?? '')) {
      return 'Invalid phone format';
    }
    return null;
  }

  static String? custom({required bool condition, required String message}) => condition ? message : null;
}
