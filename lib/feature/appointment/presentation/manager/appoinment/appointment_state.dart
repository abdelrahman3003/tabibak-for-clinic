part of 'appointment_bloc.dart';

sealed class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object> get props => [];
}

final class AppointmentInitial extends AppointmentState {}

final class AppointmentLoading extends AppointmentState {}

final class AppointmentFailed extends AppointmentState {
  final String errorMessage;

  const AppointmentFailed({required this.errorMessage});
}

final class AppointmentSuccess extends AppointmentState {
  final List<AppointmentEntity> appointmentTodayEntity;

  const AppointmentSuccess({
    required this.appointmentTodayEntity,
  });
}

final class FinishedAppointmentsLoading extends AppointmentState {}

final class FinishedAppointmentsFailed extends AppointmentState {
  final String errorMessage;

  const FinishedAppointmentsFailed({required this.errorMessage});
}

final class FinishedAppointmentsSuccess extends AppointmentState {
  final List<AppointmentEntity> finishedList;

  const FinishedAppointmentsSuccess({required this.finishedList});
}

final class CanceledAppointmentsLoading extends AppointmentState {}

final class CanceledAppointmentsFailed extends AppointmentState {
  final String errorMessage;

  const CanceledAppointmentsFailed({required this.errorMessage});
}

final class CanceledAppointmentsSuccess extends AppointmentState {
  final List<AppointmentEntity> canceledList;

  const CanceledAppointmentsSuccess({required this.canceledList});
}

final class UpcomingAppointmentsLoading extends AppointmentState {}

final class UpcomingAppointmentsFailed extends AppointmentState {
  final String errorMessage;

  const UpcomingAppointmentsFailed({required this.errorMessage});
}

final class UpcomingAppointmentsSuccess extends AppointmentState {
  final List<AppointmentEntity> upcomingList;

  const UpcomingAppointmentsSuccess({required this.upcomingList});
}

final class UpdateAppointmentStatusLoading extends AppointmentState {}

final class UpdateAppointmentStatusFailed extends AppointmentState {
  final String errorMessage;

  const UpdateAppointmentStatusFailed({required this.errorMessage});
}

final class UpdateAppointmentStatusSuccess extends AppointmentState {
  final List<AppointmentEntity>? updatedAppointmentList;
  const UpdateAppointmentStatusSuccess({
    required this.updatedAppointmentList,
  });
}
