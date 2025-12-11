import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_with_time_edit.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/update_clinic_schedule_use_case.dart';

part 'clinic_schedule_update_event.dart';
part 'clinic_schedule_update_state.dart';

class ClinicScheduleUpdateBloc
    extends Bloc<ClinicScheduleUpdateEvent, ClinicScheduleUpdateState> {
  final UpdateClinicScheduleUseCase updateClinicScheduleUseCase;
  ClinicScheduleUpdateBloc(this.updateClinicScheduleUseCase)
      : super(ClinicScheduleUpdateInitial()) {
    on<SaveClinicScheduleEvent>((event, emit) async {
      emit(ClinicScheduleUpdateLoading());
      final result =
          await updateClinicScheduleUseCase.call(event.clinicId, event.days);
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
