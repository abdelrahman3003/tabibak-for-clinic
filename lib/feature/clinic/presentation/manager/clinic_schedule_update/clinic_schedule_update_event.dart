part of 'clinic_schedule_update_bloc.dart';

sealed class ClinicScheduleUpdateEvent extends Equatable {
  const ClinicScheduleUpdateEvent();

  @override
  List<Object> get props => [];
}

class SaveClinicScheduleEvent extends ClinicScheduleUpdateEvent {
  final int clinicId;
  final List<ClinicDayWithTimeEdit> days;

  const SaveClinicScheduleEvent({required this.clinicId, required this.days});

  @override
  List<Object> get props => [clinicId, days];
}
