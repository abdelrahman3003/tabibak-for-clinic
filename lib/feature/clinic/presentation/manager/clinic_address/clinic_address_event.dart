part of 'clinic_address_bloc.dart';

sealed class ClinicAddressEvent extends Equatable {
  const ClinicAddressEvent();

  @override
  List<Object> get props => [];
}

class SaveClinicAddressEvent extends ClinicAddressEvent {
  final ClinicAddressEntity clinicAddressEntity;

  const SaveClinicAddressEvent({required this.clinicAddressEntity});
  @override
  List<Object> get props => [clinicAddressEntity];
}

class GetCitiesEvent extends ClinicAddressEvent {
  const GetCitiesEvent();
  @override
  List<Object> get props => [];
}

class GetGovernoratesEvent extends ClinicAddressEvent {
  const GetGovernoratesEvent();
  @override
  List<Object> get props => [];
}

class GetCitiesByGovernorateEvent extends ClinicAddressEvent {
  final int governorateId;

  const GetCitiesByGovernorateEvent({required this.governorateId});
  @override
  List<Object> get props => [governorateId];
}

class GetCitiesByParentEvent extends ClinicAddressEvent {
  final int parentId;

  const GetCitiesByParentEvent({required this.parentId});
  @override
  List<Object> get props => [parentId];
}
