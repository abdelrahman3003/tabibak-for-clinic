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

class GetCitiesEvent extends ClinicInfoEvent {
  const GetCitiesEvent();
  @override
  List<Object> get props => [];
}

class GetGovernoratesEvent extends ClinicInfoEvent {
  const GetGovernoratesEvent();
  @override
  List<Object> get props => [];
}

class GetCitiesByGovernorateEvent extends ClinicInfoEvent {
  final int governorateId;

  const GetCitiesByGovernorateEvent({required this.governorateId});
  @override
  List<Object> get props => [governorateId];
}

class GetCitiesByParentEvent extends ClinicInfoEvent {
  final int parentId;

  const GetCitiesByParentEvent({required this.parentId});
  @override
  List<Object> get props => [parentId];
}
