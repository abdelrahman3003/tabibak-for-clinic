part of 'appointment_type_bloc.dart';

sealed class AppointmentTypeEvent extends Equatable {
  const AppointmentTypeEvent();

  @override
  List<Object> get props => [];
}

class GetUpcomingAppointmentsEvent extends AppointmentTypeEvent {}

class GetFinishedAppointmentsEvent extends AppointmentTypeEvent {}

class GetCanceledAppointmentsEvent extends AppointmentTypeEvent {}

class UpdateAppointmentTypeStatusEvent extends AppointmentTypeEvent {
  final int statusIndex;
  final int appointmentId;
  final int type;
  final bool isToday;

  const UpdateAppointmentTypeStatusEvent(
      {required this.statusIndex,
      required this.appointmentId,
      required this.type,
      required this.isToday});
}
