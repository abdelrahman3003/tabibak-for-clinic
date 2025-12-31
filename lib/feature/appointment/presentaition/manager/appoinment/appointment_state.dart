part of 'appointment_bloc.dart';

sealed class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object> get props => [];
}

final class AppointmentInitial extends AppointmentState {}

final class AppointmentSuccess extends AppointmentState {
  final List<AppointmentEntity>? appointmentList;

  const AppointmentSuccess({
    this.appointmentList,
  });
}

final class AppointmentLoading extends AppointmentState {}

final class AppointmentFailed extends AppointmentState {
  final String errorMessage;

  const AppointmentFailed({required this.errorMessage});
}
