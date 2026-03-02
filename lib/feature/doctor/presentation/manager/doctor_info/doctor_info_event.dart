part of 'doctor_info_bloc.dart';

sealed class DoctorInfoEvent extends Equatable {
  const DoctorInfoEvent();

  @override
  List<Object> get props => [];
}

class UpdateDoctorInfo extends DoctorInfoEvent {
  final String? name;

  final String? phone;
  final String? bioAr;
  final String? bioEn;

  const UpdateDoctorInfo(
      {required this.name,
      required this.phone,
      required this.bioAr,
      required this.bioEn});
}
