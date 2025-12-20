part of 'doctor_specialty_bloc.dart';

sealed class DoctorSpecialtyEvent extends Equatable {
  const DoctorSpecialtyEvent();

  @override
  List<Object> get props => [];
}

class GetSpecialtiesEvent extends DoctorSpecialtyEvent {}

class UpdateDoctorsSpecialtyEvent extends DoctorSpecialtyEvent {
  final int specialtyId;

  const UpdateDoctorsSpecialtyEvent({required this.specialtyId});
}
