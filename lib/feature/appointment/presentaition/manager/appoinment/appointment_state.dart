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
  final AppointmentHomeEntity appointmentHomeEntity;

  const AppointmentSuccess({
    required this.appointmentHomeEntity,
  });
}

final class UpdateAppointmentStatusLoading extends AppointmentState {}

final class UpdateAppointmentStatusFailed extends AppointmentState {
  final String errorMessage;

  const UpdateAppointmentStatusFailed({required this.errorMessage});
}

final class UpdateAppointmentStatusSuccess extends AppointmentState {
  final List<AppointmentEntity>? updatedAppointmentList;

  const UpdateAppointmentStatusSuccess({required this.updatedAppointmentList});
}
