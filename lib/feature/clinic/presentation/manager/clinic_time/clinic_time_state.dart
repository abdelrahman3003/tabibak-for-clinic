part of 'clinic_time_bloc.dart';

sealed class ClinicTimeState extends Equatable {
  const ClinicTimeState();

  @override
  List<Object> get props => [];
}

final class ClinicTimeInitial extends ClinicTimeState {}

final class ClinicTimeLoading extends ClinicTimeState {}

final class ClinicTimeFailed extends ClinicTimeState {
  final String errorMessage;
  const ClinicTimeFailed({required this.errorMessage});
}

final class ClinicTimeSuccess extends ClinicTimeState {}
