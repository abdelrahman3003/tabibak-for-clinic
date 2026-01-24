// signup_event.dart
part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupRequestedEvent extends SignupEvent {
  final DoctorEntity doctorEntity;
  const SignupRequestedEvent({required this.doctorEntity});
}

class GetSpecialtiesRequested extends SignupEvent {
  const GetSpecialtiesRequested();
}

class UploadFileEvent extends SignupEvent {
  const UploadFileEvent();
}
