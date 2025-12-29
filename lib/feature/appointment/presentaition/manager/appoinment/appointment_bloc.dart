import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_appointments_use_case.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetAppointmentsUseCase getAppointmentsUseCase;
  AppointmentBloc(this.getAppointmentsUseCase) : super(AppointmentInitial()) {
    on<GetAppointmentEvent>((event, emit) async {
      final result = await getAppointmentsUseCase.call();
      result.fold(
        (error) {
          emit(AppointmentFailed(errorMessage: error.message!));
        },
        (appointmentsList) {
          emit(AppointmentSuccess(
            appointmentLength: appointmentsList.length,
            appointmentList: appointmentsList,
          ));
        },
      );
    });
    add(GetAppointmentEvent());
  }
}
