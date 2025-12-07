part of 'clinic_working_day_bloc.dart';

sealed class ClinicWorkingDayState extends Equatable {
  const ClinicWorkingDayState();

  @override
  List<Object> get props => [];
}

final class ClinicWorkingDayInitial extends ClinicWorkingDayState {}

final class ClinicWorkingDayLoading extends ClinicWorkingDayState {}

final class ClinicWorkingDayFailed extends ClinicWorkingDayState {
  final String errorMessage;

  const ClinicWorkingDayFailed({required this.errorMessage});
}

final class ClinicWorkingDaySuccess extends ClinicWorkingDayState {}

final class GetAllDaysLoading extends ClinicWorkingDayState {}

final class GetAllDaysSuccess extends ClinicWorkingDayState {
  final List<ClinicDayEntity> days;

  const GetAllDaysSuccess({required this.days});
}
