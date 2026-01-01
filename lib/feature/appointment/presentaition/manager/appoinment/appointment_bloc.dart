import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_home_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_appointments_home_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/update_appointment_status_use_case.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetAppointmentsUseCase getAppointmentsUseCase;
  final UpdateAppointmentStatusUseCase updateAppointmentStatusUseCase;
  AppointmentBloc(
      this.getAppointmentsUseCase, this.updateAppointmentStatusUseCase)
      : super(AppointmentInitial()) {
    on<GetAppointmentEvent>((event, emit) async {
      emit(AppointmentLoading());
      final result = await getAppointmentsUseCase.call();
      result.fold(
        (error) {
          emit(AppointmentFailed(errorMessage: error.message!));
        },
        (appointmentHomeEntity) {
          emit(
              AppointmentSuccess(appointmentHomeEntity: appointmentHomeEntity));
        },
      );
    });
    on<UpdateAppointmentStatusEvent>((event, emit) async {
      emit(UpdateAppointmentStatusLoading());
      final result = await updateAppointmentStatusUseCase.call(
          statusIndex: event.statusIndex, appointmentId: event.appointmentId);
      result.fold(
        (error) {
          emit(UpdateAppointmentStatusFailed(errorMessage: error.message!));
        },
        (appointmentsList) {
          emit(UpdateAppointmentStatusSuccess(
            updatedAppointmentList: appointmentsList,
          ));
        },
      );
    });
    add(GetAppointmentEvent());
  }
}
