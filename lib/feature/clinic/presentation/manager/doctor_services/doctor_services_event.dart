import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/doctor_service_entity.dart';

abstract class DoctorServicesEvent extends Equatable {
  const DoctorServicesEvent();

  @override
  List<Object?> get props => [];
}

class GetDoctorServicesEvent extends DoctorServicesEvent {
  final int clinicId;

  const GetDoctorServicesEvent({required this.clinicId});

  @override
  List<Object?> get props => [clinicId];
}

class SaveDoctorServiceEvent extends DoctorServicesEvent {
  final DoctorServiceEntity serviceEntity;
  final int clinicId;

  const SaveDoctorServiceEvent({
    required this.serviceEntity,
    required this.clinicId,
  });

  @override
  List<Object?> get props => [serviceEntity, clinicId];
}

class DeleteDoctorServiceEvent extends DoctorServicesEvent {
  final int serviceId;
  final int clinicId;

  const DeleteDoctorServiceEvent({
    required this.serviceId,
    required this.clinicId,
  });

  @override
  List<Object?> get props => [serviceId, clinicId];
}
