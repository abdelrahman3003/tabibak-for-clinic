part of 'doctor_education_bloc.dart';

sealed class DoctorEducationEvent extends Equatable {
  const DoctorEducationEvent();

  @override
  List<Object> get props => [];
}

class GetDoctorCertificatesEvent extends DoctorEducationEvent {
  const GetDoctorCertificatesEvent();
}

class UpdateDoctorEducationEvent extends DoctorEducationEvent {
  final List<XFile?> files;
  final EducationEntity educationEntity;

  const UpdateDoctorEducationEvent(
      {required this.files, required this.educationEntity});
}
