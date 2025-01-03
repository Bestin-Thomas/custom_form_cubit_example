import 'package:freezed_annotation/freezed_annotation.dart';

import '../../form/application/generic_form_cubit.dart';
import '../../form/form_field_controller.dart';
import '../../login/application/login_form_state.dart';

part 'address_details_state.freezed.dart';

@freezed
class AddressDetailsState with _$AddressDetailsState implements GenericFormState<AddressDetailsFormModel> {
  factory AddressDetailsState({required AddressDetailsFormModel formModel}) = _AddressDetailsState;
}

class AddressDetailsFormModel extends GenericFormModel {
  final houseName = GenericFieldController<String>(
    null,
    validators: [
      (value) => FormValidators.required(value),
    ],
  );
  final country = GenericFieldController<String>(
    null,
    validators: [
      (value) => FormValidators.required(value),
    ],
  );
  final state = GenericFieldController<String>(
    null,
    validators: [
      (value) => FormValidators.required(value),
    ],
  );
  final district = GenericFieldController<String>(
    null,
    validators: [
      (value) => FormValidators.required(value),
    ],
  );
  final city = GenericFieldController<String>(
    null,
    validators: [
      (value) => FormValidators.required(value),
    ],
  );
  final pinCode = GenericFieldController<String>(
    null,
    validators: [
      (value) => FormValidators.required(value),
      (value) => FormValidators.length(value, fieldName: 'Pin Code', maxLength: 6, minLength: 6),
    ],
  );

  @override
  // TODO: implement controls
  List<GenericFieldController> get controls => [
        houseName,
        country,
        state,
        district,
        city,
        pinCode,
      ];
}
