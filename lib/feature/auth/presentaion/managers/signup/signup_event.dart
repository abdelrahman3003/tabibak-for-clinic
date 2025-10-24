// signup_event.dart
part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupRequested extends SignupEvent {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String image;
  final String bio;
  final int specialty;
  final String clinicName;
  final String address;
  final double consultationFee;
  final String clinicPhone;
  final String universityName;
  final int graduationYear;
  final String nationalId;
  final String medicalLiecense;
  final List<WorkDayShift> workDayShifts;

  const SignupRequested({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.image,
    required this.bio,
    required this.specialty,
    required this.clinicName,
    required this.address,
    required this.consultationFee,
    required this.clinicPhone,
    required this.universityName,
    required this.graduationYear,
    required this.workDayShifts,
    required this.nationalId,
    required this.medicalLiecense,
  });
}
