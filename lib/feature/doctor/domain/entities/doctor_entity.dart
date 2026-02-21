import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/education_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/specialty_entity.dart';

class DoctorEntity extends Equatable {
  final String? name;
  final String? email;
  final String? phone;
  final String? image;
  final int? specialty;
  final String? medicalLicense;
  final String? password;
  final String? bioAr;
  final String? bioEn;
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
    this.medicalLicense,
    this.password,
    this.bioAr,
    this.bioEn,
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

  DoctorEntity copyWith({
    String? medicalLicense,
  }) {
    return DoctorEntity(
      name: name,
      phone: phone,
      email: email,
      image: image,
      specialty: specialty,
      medicalLicense: medicalLicense ?? this.medicalLicense,
      password: password,
      bioAr: bioAr,
      bioEn: bioAr,
      isVerified: isVerified,
      isRegistered: isRegistered,
      education: education,
      specialtyData: specialtyData,
      files: files,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        phone,
        image,
        specialty,
        medicalLicense,
        password,
        bioAr,
        bioEn,
        isVerified,
        isRegistered,
        specialtyData,
        files,
      ];
}
