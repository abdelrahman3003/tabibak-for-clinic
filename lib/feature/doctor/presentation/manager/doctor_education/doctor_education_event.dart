part of 'doctor_education_bloc.dart';

sealed class DoctorEducationEvent extends Equatable {
  const DoctorEducationEvent();

  @override
  List<Object> get props => [];
}

class UpdateDoctorEducationEvent extends DoctorEducationEvent {
  final XFile? file;
  final EducationEntity educationEntity;

  const UpdateDoctorEducationEvent(
      {required this.file, required this.educationEntity});
}
