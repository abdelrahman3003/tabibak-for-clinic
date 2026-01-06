part of 'appointment_type_bloc.dart';

sealed class AppointmentTypeEvent extends Equatable {
  const AppointmentTypeEvent();

  @override
  List<Object> get props => [];
}

class GetUpcomingAppointmentsEvent extends AppointmentTypeEvent {}

class GetFinishedAppointmentsEvent extends AppointmentTypeEvent {}

class GetCanceledAppointmentsEvent extends AppointmentTypeEvent {}
