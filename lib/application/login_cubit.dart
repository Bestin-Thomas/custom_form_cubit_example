import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_form_state.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormModel _formModel = LoginFormModel();
  LoginFormCubit() : super(LoginFormState(loginForm: LoginFormModel()));

  void updateValues({
    required LoginFormModel loginForm,
  }) {
    _formModel = loginForm;
    _updateFormValidity();
  }

  void resetForm() {
    final loginForm = state.loginForm;
    loginForm.reset();
    emit(LoginFormState(loginForm: loginForm));
  }

  void _updateFormValidity() {
    final isValid = _formModel.isValid;

    log('Form validity: $isValid');
    log('Name error: ${_formModel.name.error}');
    log('Email error: ${_formModel.email.error}');
    log('Phone error: ${_formModel.phone.error}');

    emit(LoginFormState(loginForm: _formModel));
  }
}
