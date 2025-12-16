import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_working_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/save_clinic_working_day_use_case.dart';

part 'clinic_schedule_update_event.dart';
part 'clinic_schedule_update_state.dart';

class ClinicScheduleUpdateBloc
    extends Bloc<ClinicScheduleUpdateEvent, ClinicScheduleUpdateState> {
  final SaveClinicWorkingDayUseCase updateClinicScheduleUseCase;
  ClinicScheduleUpdateBloc(this.updateClinicScheduleUseCase)
      : super(ClinicScheduleUpdateInitial()) {
    on<SaveClinicScheduleEvent>((event, emit) async {
      emit(ClinicScheduleUpdateLoading());
      final result = await updateClinicScheduleUseCase.call(
          clinicId: event.clinicId, days: event.days);
      result.fold(
        (error) {
          emit(ClinicScheduleUpdateFailed(errorMessage: error.message!));
        },
        (_) {
          emit(ClinicScheduleUpdateSuccess());
        },
      );
    });
  }
}
