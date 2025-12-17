part of 'doctor_profile_bloc.dart';

sealed class DoctorProfileEvent extends Equatable {
  const DoctorProfileEvent();

  @override
  List<Object> get props => [];
}

class GetDoctorProfileEvent extends DoctorProfileEvent {}
