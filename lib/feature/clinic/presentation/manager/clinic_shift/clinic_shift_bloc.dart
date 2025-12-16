import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_working_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/save_clinic_working_day_use_case.dart';

part 'clinic_shift_event.dart';
part 'clinic_shift_state.dart';

class ClinicShiftBloc extends Bloc<ClinicShiftEvent, ClinicShiftState> {
  final SaveClinicWorkingDayUseCase updateClinicScheduleUseCase;
  ClinicShiftBloc(this.updateClinicScheduleUseCase)
      : super(ClinicShiftInitial()) {
    on<CreateClinicShiftEvent>((event, emit) async {
      emit(ClinicShiftLoading());

      final result = await updateClinicScheduleUseCase.call(
        clinicId: event.clinicId,
        days: event.days,
      );
      result.fold(
        (error) {
          emit(ClinicShiftFailed(errorMessage: error.message!));
        },
        (id) {
          emit(ClinicShiftSuccess());
        },
      );
    });
    on<UpdateClinicShiftEvent>((event, emit) async {
      emit(ClinicShiftLoading());
      final result = await updateClinicScheduleUseCase.call(
          clinicId: event.clinicId, days: event.days);
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
