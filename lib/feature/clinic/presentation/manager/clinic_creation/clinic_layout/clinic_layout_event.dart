part of 'clinic_layout_bloc.dart';

sealed class ClinicLayoutEvent extends Equatable {
  const ClinicLayoutEvent();

  @override
  List<Object> get props => [];
}

class GetClinicInfoEvent extends ClinicLayoutEvent {
  const GetClinicInfoEvent();
}

class GetClinicScheduleEvent extends ClinicLayoutEvent {
  final int clinicId;

  const GetClinicScheduleEvent({required this.clinicId});
}
