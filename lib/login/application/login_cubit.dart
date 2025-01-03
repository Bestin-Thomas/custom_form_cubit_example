import '../../form/application/generic_form_cubit.dart';
import 'login_form_state.dart';

class RegistrationFormCubit
    extends GenericFormCubit<RegistrationFormModel, RegistrationFormState> {
  RegistrationFormCubit()
      : super(
    RegistrationFormState(formModel: RegistrationFormModel()),
  );

  void setLoading({
    required RegistrationFormModel formModel,
    bool loading = false,
  }) {
    updateForm(formModel);
    emit(state.copyWith(isLoading: loading));
  }

  @override
  createState({
    RegistrationFormModel? model,
  }) => state.copyWith(formModel: model ?? state.formModel);
}
