import 'package:equatable/equatable.dart';

class DoctorEntity extends Equatable {
  final String name;
  final String phone;
  final String image;
  final String bio;
  final int specialty;
  final String nationalId;
  final String medicalLiecense;

  const DoctorEntity({
    required this.name,
    required this.phone,
    required this.image,
    required this.bio,
    required this.specialty,
    required this.nationalId,
    required this.medicalLiecense,
  });

  @override
  List<Object?> get props =>
      [name, phone, image, specialty, bio, nationalId, medicalLiecense];
}
