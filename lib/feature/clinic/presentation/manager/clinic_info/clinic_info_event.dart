part of 'clinic_info_bloc.dart';

sealed class ClinicInfoEvent extends Equatable {
  const ClinicInfoEvent();

  @override
  List<Object> get props => [];
}

class CreateClinicInfoEvent extends ClinicInfoEvent {
  final ClinicInfoEntity clinicInfoEntity;

  const CreateClinicInfoEvent({required this.clinicInfoEntity});
}
