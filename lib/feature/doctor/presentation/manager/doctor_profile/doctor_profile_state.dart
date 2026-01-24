part of 'doctor_profile_bloc.dart';

sealed class DoctorProfileState extends Equatable {
  const DoctorProfileState();

  @override
  List<Object> get props => [];
}

final class DoctorProfileInitial extends DoctorProfileState {}

final class DoctorProfileLoading extends DoctorProfileState {}

final class DoctorProfileFailed extends DoctorProfileState {
  final String errorMessage;

  const DoctorProfileFailed({required this.errorMessage});
}

final class DoctorProfileSuccess extends DoctorProfileState {
  final DoctorEntity doctorEntity;

  const DoctorProfileSuccess({required this.doctorEntity});
}

final class UploadImageProfileLoading extends DoctorProfileState {}

final class UploadImageProfileSuccess extends DoctorProfileState {}

final class UploadImageProfileFailed extends DoctorProfileState {}

final class LogOutDoctorLoading extends DoctorProfileState {}

final class LogOutDoctorSuccess extends DoctorProfileState {}

final class LogOutDoctorFailed extends DoctorProfileState {
  final String errorMessage;

  const LogOutDoctorFailed({required this.errorMessage});
}
