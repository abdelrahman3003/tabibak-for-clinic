part of 'clinic_time_bloc.dart';

sealed class ClinicTimeEvent extends Equatable {
  const ClinicTimeEvent();

  @override
  List<Object> get props => [];
}

class CreateClinicTimeEvent extends ClinicTimeEvent {
  final ClinicTimeEntity clinicTimeEntity;

  const CreateClinicTimeEvent({required this.clinicTimeEntity});
}
