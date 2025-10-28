// signup_event.dart
part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupRequested extends SignupEvent {
  final DoctorEntity doctorEntity;
  final String password;
  final User? user;

  const SignupRequested(
      {required this.doctorEntity, required this.password, required this.user});
}

class GetSpecialtiesRequested extends SignupEvent {
  const GetSpecialtiesRequested();
}

class UploadFileEvent extends SignupEvent {
  const UploadFileEvent();
}
