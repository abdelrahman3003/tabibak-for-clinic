part of 'clinic_shift_bloc.dart';

sealed class ClinicShiftEvent extends Equatable {
  const ClinicShiftEvent();

  @override
  List<Object> get props => [];
}

final class CreateClinicShiftEvent extends ClinicShiftEvent {
  final int clinicId;
  final List<ClinicDayWithTimes> days;
  const CreateClinicShiftEvent(this.clinicId, this.days);
}
