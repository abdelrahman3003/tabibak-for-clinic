part of 'clinic_working_day_bloc.dart';

sealed class ClinicWorkingDayEvent extends Equatable {
  const ClinicWorkingDayEvent();

  @override
  List<Object> get props => [];
}

class GetAllDaysEvent extends ClinicWorkingDayEvent {}
