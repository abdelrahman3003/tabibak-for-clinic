import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_time_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/create_clinic_working_day_shift_use_case.dart';

part 'clinic_shift_event.dart';
part 'clinic_shift_state.dart';

class ClinicShiftBloc extends Bloc<ClinicShiftEvent, ClinicShiftState> {
  final CreateClinicWorkingDayShiftUseCase createClinicWorkingDayShiftUseCase;
  ClinicShiftBloc(this.createClinicWorkingDayShiftUseCase)
      : super(ClinicShiftInitial()) {
    on<CreateClinicShiftEvent>((event, emit) async {
      emit(ClinicShiftLoading());
      final result = await createClinicWorkingDayShiftUseCase.call(
          dayId: event.dayId,
          morningTime: event.morningTime,
          eveningTime: event.eveningTime,
          clinicId: event.clinicId);
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
