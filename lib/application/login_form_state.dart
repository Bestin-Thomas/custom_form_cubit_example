import 'package:freezed_annotation/freezed_annotation.dart';
import '../form/form_field_controller.dart';

part 'login_form_state.freezed.dart';

@freezed
class LoginFormState with _$LoginFormState {
  factory LoginFormState({
    required LoginFormModel loginForm,
  }) = _LoginFormState;
}

class LoginFormModel extends FormModel {
  final name = FormControl<String>(null, validators: [
    (value) => value?.isEmpty ?? true ? FormError('Name is required') : null,
    (value) =>
        (value?.length ?? 0) < 2 ? FormError('Name must be at least 2 characters') : null,
  ]);

  final email = FormControl<String>(null, validators: [
    (value) => value?.isEmpty ?? true ? FormError('Email is required') : null,
    (value) => FormValidators.validateEmail(value ?? ''),
  ]);

  final phone = FormControl<String>(null, validators: [
    (value) => value?.isEmpty ?? true ? FormError('Phone is required') : null,
    (value) => FormValidators.validatePhone(value ?? ''),
  ]);

  @override
  List<FormControl> get controls => [name, email, phone];

  LoginFormModel() {
    // Custom validation after initialization
    email.addValidations( [_validateEmailDependsOnName,]);
  }

  FormError? _validateEmailDependsOnName(String ? value) {
    // Check if the 'name' field is empty, and if so, return the validation error
    if (name.value?.isEmpty ?? true) {
      return FormError('Name is required for email');
    }
    return null;
  }


}

class FormValidators {
  static FormError? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return FormError('Name is required');
    } else if (value.length < 2) {
      return FormError('Name must be at least 2 characters');
    }
    return null;
  }

  static FormError? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return FormError('Email is required');
    } else if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zAZ0-9]+').hasMatch(value)) {
      return FormError('Invalid email format');
    }
    return null;
  }

  static FormError? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return FormError('Phone is required');
    } else if (!RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(value)) {
      return FormError('Invalid phone format');
    }
    return null;
  }
}
