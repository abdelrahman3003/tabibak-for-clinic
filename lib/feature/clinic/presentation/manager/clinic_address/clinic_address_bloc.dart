import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_address_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/save_clinic_address_use_case.dart';

part 'clinic_address_event.dart';
part 'clinic_address_state.dart';

class ClinicAddressBloc extends Bloc<ClinicAddressEvent, ClinicAddressState> {
  final SaveClinicAddressUseCase saveClinicAddressUseCase;
  ClinicAddressBloc(this.saveClinicAddressUseCase)
      : super(ClinicAddressInitial()) {
    on<SaveClinicAddressEvent>((event, emit) async {
      emit(ClinicAddressLoading());
      final result =
          await saveClinicAddressUseCase.call(event.clinicAddressEntity);
      result.fold(
        (error) {
          emit(ClinicAddressFailed(errorMessage: error.message!));
        },
        (success) {
          emit(ClinicAddressSuccess());
        },
      );
    });
  }
}
