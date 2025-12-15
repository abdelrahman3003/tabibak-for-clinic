part of 'clinic_shift_bloc.dart';

sealed class ClinicShiftEvent extends Equatable {
  const ClinicShiftEvent();

  @override
  List<Object> get props => [];
}

final class CreateClinicShiftEvent extends ClinicShiftEvent {
  final int clinicId;
  final List<ClinicWorkingDayModel> days;

  const CreateClinicShiftEvent(this.clinicId, this.days);
}

class UpdateClinicShiftEvent extends ClinicShiftEvent {
  final int clinicId;
  final List<ClinicWorkingDayModel> days;

  const UpdateClinicShiftEvent({required this.clinicId, required this.days});

  @override
  List<Object> get props => [clinicId, days];
}
