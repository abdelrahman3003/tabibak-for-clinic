part of 'clinic_working_day_bloc.dart';

sealed class ClinicWorkingDayEvent extends Equatable {
  const ClinicWorkingDayEvent();

  @override
  List<Object> get props => [];
}

class CreateClinicWorkingDayEvent extends ClinicWorkingDayEvent {
  final ClinicWorkingDayEntity clinicWorkingDayEntity;

  const CreateClinicWorkingDayEvent({required this.clinicWorkingDayEntity});
}
