import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/doctor_service_entity.dart';

abstract class DoctorServicesState extends Equatable {
  const DoctorServicesState();

  @override
  List<Object?> get props => [];
}

class DoctorServicesInitial extends DoctorServicesState {}

class DoctorServicesLoading extends DoctorServicesState {}

class DoctorServicesLoaded extends DoctorServicesState {
  final List<DoctorServiceEntity> services;

  const DoctorServicesLoaded({required this.services});

  @override
  List<Object?> get props => [services];
}

class DoctorServicesActionLoading extends DoctorServicesState {}

class DoctorServicesActionSuccess extends DoctorServicesState {
  final bool isDelete;
  final String? message;

  const DoctorServicesActionSuccess({
    this.isDelete = false,
    this.message,
  });

  @override
  List<Object?> get props => [isDelete, message];
}

class DoctorServicesError extends DoctorServicesState {
  final String errorMessage;

  const DoctorServicesError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
