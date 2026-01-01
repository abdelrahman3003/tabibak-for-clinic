part of 'appointment_bloc.dart';

sealed class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object> get props => [];
}

class GetAppointmentEvent extends AppointmentEvent {}

class UpdateAppointmentStatusEvent extends AppointmentEvent {
  final int statusIndex;
  final int appointmentId;

  const UpdateAppointmentStatusEvent(
      {required this.statusIndex, required this.appointmentId});
}
