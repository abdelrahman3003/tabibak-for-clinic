part of 'doctor_specialty_bloc.dart';

sealed class DoctorSpecialtyState extends Equatable {
  const DoctorSpecialtyState();

  @override
  List<Object> get props => [];
}

final class DoctorSpecialtyInitial extends DoctorSpecialtyState {}

final class DoctorGetSpecialtiesLoading extends DoctorSpecialtyState {}

final class DoctorGetSpecialtiesFailed extends DoctorSpecialtyState {
  final String errorMessage;

  const DoctorGetSpecialtiesFailed({required this.errorMessage});
}

final class DoctorGetSpecialtiesSuccess extends DoctorSpecialtyState {
  final List<SpecialtyEntity> specialties;

  const DoctorGetSpecialtiesSuccess({required this.specialties});
}

final class DoctorUpdateSpecialtyLoading extends DoctorSpecialtyState {}

final class DoctorUpdateSpecialtyFailed extends DoctorSpecialtyState {
  final String errorMessage;

  const DoctorUpdateSpecialtyFailed({required this.errorMessage});
}

final class DoctorUpdateSpecialtySuccess extends DoctorSpecialtyState {}
