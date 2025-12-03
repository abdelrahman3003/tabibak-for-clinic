import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/create_clinic_shift_use_case.dart';

part 'clinic_shift_event.dart';
part 'clinic_shift_state.dart';

class ClinicShiftBloc extends Bloc<ClinicShiftEvent, ClinicShiftState> {
  final CreateClinicShiftUseCase createClinicShiftUseCase;
  ClinicShiftBloc(this.createClinicShiftUseCase) : super(ClinicShiftInitial()) {
    on<CreateClinicShiftEvent>((event, emit) async {
      emit(ClinicShiftLoading());
      final result =
          await createClinicShiftUseCase.call(event.clinicShiftEntity);
      result.fold(
        (error) {
          emit(ClinicShiftFailed(errorMessage: error.message!));
        },
        (id) {
          emit(ClinicShiftSuccess());
        },
      );
    });
  }
}
