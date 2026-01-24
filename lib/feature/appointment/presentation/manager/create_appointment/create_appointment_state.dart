part of 'create_appointment_bloc.dart';

sealed class CreateAppointmentState extends Equatable {
  const CreateAppointmentState();

  @override
  List<Object> get props => [];
}

final class CreateAppointmentInitial extends CreateAppointmentState {}

final class GetAppointmentShiftLoading extends CreateAppointmentState {}

final class GetAppointmentShiftSuccess extends CreateAppointmentState {
  final ClinicShiftEntity? clinicShiftEntity;

  const GetAppointmentShiftSuccess({required this.clinicShiftEntity});
  @override
  List<Object> get props => [clinicShiftEntity ?? 'null'];
}

final class GetAppointmentShiftFailed extends CreateAppointmentState {
  final String errorMessage;

  const GetAppointmentShiftFailed({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

final class AddAppointmentLoading extends CreateAppointmentState {}

final class AddAppointmentSuccess extends CreateAppointmentState {}

final class AddAppointmentFailed extends CreateAppointmentState {
  final String errorMessage;

  const AddAppointmentFailed({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
