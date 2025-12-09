part of 'clinic_shift_bloc.dart';

sealed class ClinicShiftEvent extends Equatable {
  const ClinicShiftEvent();

  @override
  List<Object> get props => [];
}

final class CreateClinicShiftEvent extends ClinicShiftEvent {
  final ClinicTimeEntity morningTime;
  final ClinicTimeEntity eveningTime;
  final int dayId;
  final int clinicId;
  const CreateClinicShiftEvent({
    required this.dayId,
    required this.morningTime,
    required this.eveningTime,
    required this.clinicId,
  });
}
