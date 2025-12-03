part of 'clinic_shift_bloc.dart';

sealed class ClinicShiftState extends Equatable {
  const ClinicShiftState();

  @override
  List<Object> get props => [];
}

final class ClinicShiftInitial extends ClinicShiftState {}

final class ClinicShiftLoading extends ClinicShiftState {}

final class ClinicShiftFailed extends ClinicShiftState {
  final String errorMessage;

  const ClinicShiftFailed({required this.errorMessage});
}

final class ClinicShiftSuccess extends ClinicShiftState {}
