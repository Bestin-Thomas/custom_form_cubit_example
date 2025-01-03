import 'dart:developer';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../form_field_controller.dart';


abstract class GenericFormState<T extends GenericFormModel> {
  T get formModel;
}

// Base form cubit that handles common form operations
abstract class GenericFormCubit<T extends GenericFormModel,
    S extends GenericFormState<T>> extends Cubit<S> {
  GenericFormCubit(super.initialState);

  void updateForm(T model) {
    model.validate();
    emit(createState(model: model));
  }

  void resetForm() {
    final formModel = state.formModel;
    formModel.reset();
    formModel.validate();
    emit(createState(model: formModel));
  }

  void disposeForm() {
    final currentState = state;
    final formModel = currentState.formModel;
    formModel.dispose();
    emit(createState(model: formModel));
  }

  void submit({required VoidCallback validAction, VoidCallback? inValidAction}) {
    final currentState = state;
    final formModel = currentState.formModel;
    formModel.validate();
    final  value = formModel.controls.map( (e) =>  e.value.toString(),);
    log(value.join(', '));
    final  error = formModel.controls.map( (e) =>  e.error.value ?? '',);
    log(error.join(', '));
    emit(createState(model: formModel));
    if (formModel.isValid) {
      validAction.call();
    } else {
      inValidAction?.call();
    }
  }

  S createState({
    T? model,
  });
}
