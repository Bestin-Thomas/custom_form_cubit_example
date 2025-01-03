import 'package:custom_form_cubit_example/address/application/address_details_state.dart';

import '../../form/application/generic_form_cubit.dart';

class AddressDetailsCubit extends GenericFormCubit<AddressDetailsFormModel, AddressDetailsState> {
  AddressDetailsCubit()
      : super(
          AddressDetailsState(
            formModel: AddressDetailsFormModel(),
          ),
        );

  @override
  AddressDetailsState createState({AddressDetailsFormModel? model}) =>
      state.copyWith(formModel: model ?? state.formModel);
}
