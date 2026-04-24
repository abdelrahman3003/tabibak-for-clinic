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

class UpdateAppointmentEvent extends AppointmentDetailsEvent {
  final String actionType; // "cancel" or "followUp"
  final int appointmentId;

  const UpdateAppointmentEvent({
    required this.appointmentId,
    required this.actionType,
  });

  @override
  List<Object> get props => [appointmentId];
}

class SetFollowUpEvent extends AppointmentDetailsEvent {
  final DateTime date;
  final int appointmentId;

  const SetFollowUpEvent({
    required this.date,
    required this.appointmentId,
  });
}
