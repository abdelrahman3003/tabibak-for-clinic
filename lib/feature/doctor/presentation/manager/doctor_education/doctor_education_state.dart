part of 'doctor_education_bloc.dart';

sealed class DoctorEducationState extends Equatable {
  const DoctorEducationState();

  @override
  List<Object> get props => [];
}

final class DoctorEducationInitial extends DoctorEducationState {}

final class DoctorCertificatesLoading extends DoctorEducationState {}

final class DoctorCertificatesSuccess extends DoctorEducationState {
  final List<DoctorFileEntity> doctorFilesEntities;

  const DoctorCertificatesSuccess({required this.doctorFilesEntities});
}

final class DoctorEducationLoading extends DoctorEducationState {}

final class DoctorEducationFailed extends DoctorEducationState {
  final String errorMessage;

  const DoctorEducationFailed({required this.errorMessage});
}

final class DoctorEducationSuccess extends DoctorEducationState {}
