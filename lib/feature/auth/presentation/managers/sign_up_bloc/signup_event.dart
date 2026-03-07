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

class GetSpecialtiesEvent extends SignupEvent {
  const GetSpecialtiesEvent();
  @override
  List<Object> get props => [];
}
