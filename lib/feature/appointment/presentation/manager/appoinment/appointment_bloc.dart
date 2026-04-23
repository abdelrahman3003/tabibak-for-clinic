import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_appointments_use_case.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart'
    show DoctorEntity;
import 'package:tabibak_for_clinic/feature/doctor/domain/usecase/get_doctor_use_case.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetAppointmentsUseCase getAppointmentsUseCase;
  final GetDoctorUseCase getDoctorUseCase;
  AppointmentBloc(this.getAppointmentsUseCase, this.getDoctorUseCase)
      : super(AppointmentInitial()) {
    on<GetAppointmentEvent>((event, emit) async {
      emit(AppointmentLoading());

      final appointmentResult =
          await getAppointmentsUseCase.call(type: 5, isToday: true);
      final doctorResult = await getDoctorUseCase.call();

      appointmentResult.fold(
        (error) {
          emit(AppointmentFailed(errorMessage: error.message!));
        },
        (appointmentsList) {
          doctorResult.fold(
            (error) {
              emit(AppointmentFailed(errorMessage: error.message!));
            },
            (doctor) {
              emit(
                AppointmentSuccess(
                  doctor: doctor,
                  appointmentsList: appointmentsList,
                ),
              );
            },
          );
        },
      );
    });

    on<GetDoctorEvent>((event, emit) async {
      emit(GetDoctorLoading());
      final result = await getDoctorUseCase.call();
      result.fold(
        (error) {
          emit(AppointmentFailed(errorMessage: error.message!));
        },
        (doctor) {
          emit(GetDoctorSuccess(doctor: doctor));
        },
      );
    });

    add(const GetAppointmentEvent());
  }
}
