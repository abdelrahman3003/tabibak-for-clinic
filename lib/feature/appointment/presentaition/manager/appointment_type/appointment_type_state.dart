part of 'appointment_type_bloc.dart';

sealed class AppointmentTypeState extends Equatable {
  const AppointmentTypeState();

  @override
  List<Object> get props => [];
}

final class AppointmentTypeInitial extends AppointmentTypeState {}

final class UpcomingAppointmentsLoading extends AppointmentTypeState {}

final class UpcomingAppointmentsFailed extends AppointmentTypeState {
  final String errorMessage;

  const UpcomingAppointmentsFailed({required this.errorMessage});
}

final class UpcomingAppointmentsSuccess extends AppointmentTypeState {
  final List<AppointmentEntity> upcomingList;

  const UpcomingAppointmentsSuccess({required this.upcomingList});
}

final class FinishedAppointmentsLoading extends AppointmentTypeState {}

final class FinishedAppointmentsFailed extends AppointmentTypeState {
  final String errorMessage;

  const FinishedAppointmentsFailed({required this.errorMessage});
}

final class FinishedAppointmentsSuccess extends AppointmentTypeState {
  final List<AppointmentEntity> upcomingList;

  const FinishedAppointmentsSuccess({required this.upcomingList});
}

final class CanceledAppointmentsLoading extends AppointmentTypeState {}

final class CanceledAppointmentsFailed extends AppointmentTypeState {
  final String errorMessage;

  const CanceledAppointmentsFailed({required this.errorMessage});
}

final class CanceledAppointmentsSuccess extends AppointmentTypeState {
  final List<AppointmentEntity> upcomingList;

  const CanceledAppointmentsSuccess({required this.upcomingList});
}
