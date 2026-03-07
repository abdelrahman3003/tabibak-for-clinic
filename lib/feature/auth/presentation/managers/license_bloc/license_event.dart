part of 'license_bloc.dart';

sealed class LicenseEvent extends Equatable {
  const LicenseEvent();

  @override
  List<Object> get props => [];
}

class UploadFileEvent extends LicenseEvent {
  const UploadFileEvent();
  @override
  List<Object> get props => [];
}

class AddDoctorEvent extends LicenseEvent {
  final DoctorEntity doctorEntity;
  const AddDoctorEvent({required this.doctorEntity});
  @override
  List<Object> get props => [doctorEntity];
}
