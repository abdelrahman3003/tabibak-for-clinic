import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/education_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/specialty_entity.dart';

class DoctorEntity extends Equatable {
  final String? name;
  final String? email;
  final String? phone;
  final String? image;
  final int? specialty;
  final String? medicalLiecense;
  final String? password;
  final String? bio;
  final bool? isVerified;
  final bool? isRegistered;
  final EducationEntity? education;
  final SpecialtyEntity? specialtyData;
  final List<String>? files;

  const DoctorEntity({
    this.name,
    this.phone,
    this.email,
    this.image,
    this.specialty,
    this.medicalLiecense,
    this.password,
    this.bio,
    this.isVerified,
    this.isRegistered,
    this.education,
    this.specialtyData,
    this.files,
  });

  Map<String, dynamic> filesMap() {
    return {
      'files': files ?? [],
    };
  }

  @override
  List<Object?> get props => [
        name,
        email,
        phone,
        image,
        specialty,
        medicalLiecense,
        password,
        bio,
        isVerified,
        isRegistered,
        specialtyData,
        files,
      ];
}
