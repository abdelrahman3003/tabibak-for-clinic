part of 'doctor_education_bloc.dart';

sealed class DoctorEducationState extends Equatable {
  const DoctorEducationState();

  @override
  List<Object> get props => [];
}

final class DoctorEducationInitial extends DoctorEducationState {}

final class DoctorEducationLoading extends DoctorEducationState {}

final class DoctorEducationFailed extends DoctorEducationState {
  final String errorMessage;

  const DoctorEducationFailed({required this.errorMessage});
}

final class DoctorEducationSuccess extends DoctorEducationState {}
