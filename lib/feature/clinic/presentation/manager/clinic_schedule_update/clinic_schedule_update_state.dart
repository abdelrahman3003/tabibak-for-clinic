part of 'clinic_schedule_update_bloc.dart';

sealed class ClinicScheduleUpdateState extends Equatable {
  const ClinicScheduleUpdateState();

  @override
  List<Object> get props => [];
}

final class ClinicScheduleUpdateInitial extends ClinicScheduleUpdateState {}

final class ClinicScheduleUpdateLoading extends ClinicScheduleUpdateState {}

final class ClinicScheduleUpdateFailed extends ClinicScheduleUpdateState {
  final String errorMessage;

  const ClinicScheduleUpdateFailed({required this.errorMessage});
}

final class ClinicScheduleUpdateSuccess extends ClinicScheduleUpdateState {}
