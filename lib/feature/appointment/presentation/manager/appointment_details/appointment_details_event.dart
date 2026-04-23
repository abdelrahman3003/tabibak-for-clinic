part of 'appointment_details_bloc.dart';

sealed class AppointmentDetailsEvent extends Equatable {
  const AppointmentDetailsEvent();
  @override
  List<Object> get props => [];
}

class GetAppointmentDetailsEvent extends AppointmentDetailsEvent {
  final int appointmentId;

  const GetAppointmentDetailsEvent({
    required this.appointmentId,
  });

  @override
  List<Object> get props => [appointmentId];
}

class CancelAppointmentEvent extends AppointmentDetailsEvent {
  final int appointmentId;

  const CancelAppointmentEvent({
    required this.appointmentId,
  });

  @override
  List<Object> get props => [appointmentId];
}
