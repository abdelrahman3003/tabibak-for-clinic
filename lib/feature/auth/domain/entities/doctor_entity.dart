import 'package:equatable/equatable.dart';

class DoctorEntity extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String? image;
  final int specialty;
  final String medicalLiecense;

  const DoctorEntity({
    required this.name,
    required this.phone,
    required this.email,
    this.image,
    required this.specialty,
    required this.medicalLiecense,
  });

  @override
  List<Object?> get props =>
      [name, email, phone, image, specialty, medicalLiecense];
}
