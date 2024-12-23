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
    (value) => value?.isEmpty ?? true ? 'Name is required' : null,
    (value) =>
        (value?.length ?? 0) < 2 ? 'Name must be at least 2 characters' : null,
  ]);

  final email = FormControl<String>(null, validators: [
    (value) => value?.isEmpty ?? true ? 'Email is required' : null,
    (value) => !FormValidators.isValidEmail(value ?? '')
        ? 'Invalid email format'
        : null,
  ]);

  final phone = FormControl<String>(null, validators: [
    (value) => value?.isEmpty ?? true ? 'Phone is required' : null,
    (value) => !FormValidators.isValidPhone(value ?? '')
        ? 'Invalid phone format'
        : null,
  ]);

  @override
  List<FormControl> get controls => [name, email, phone];
}

class FormValidators {
  static bool isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegExp.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    final phoneRegExp = RegExp(
      r'^\+?[\d\s-]{10,}$',
    );
    return phoneRegExp.hasMatch(phone);
  }
}
