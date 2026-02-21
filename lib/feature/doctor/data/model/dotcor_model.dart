import 'package:tabibak_for_clinic/feature/doctor/data/model/education_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/specialty_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';

class DoctorModel extends DoctorEntity {
  const DoctorModel(
      {super.name,
      super.phone,
      super.image,
      super.specialty,
      super.medicalLicense,
      super.email,
      super.password,
      super.bioAr,
      super.bioEn,
      super.isVerified,
      super.isRegistered,
      super.education,
      super.specialtyData,
      super.files});
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "email": email,
      "image": image,
      "specialty": specialty,
      "medical_liecense": medicalLicense,
      "bio_ar": bioAr,
      "bio_en": bioEn,
      "is_verified": isVerified,
      "is_registered": isRegistered,
    };
  }

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      image: json['image'] as String?,
      specialty: json['specialty'] as int,
      medicalLicense: json['medical_liecense'] as String,
      bioAr: json['bio_ar'] as String?,
      bioEn: json['bio_en'] as String?,
      isVerified: json['is_verified'] as bool?,
      isRegistered: json['is_registered'] as bool?,
      education: json['education'] != null
          ? EducationModel.fromJson(json['education'])
          : null,
      specialtyData: json['specialties'] != null
          ? SpecialtyModel.fromJson(json['specialties'])
          : null,
      files: json['files'] != null
          ? List<String>.from(
              (json['files'] as List).map((f) => f['file'] as String))
          : null,
    );
  }
  factory DoctorModel.fromEntity(DoctorEntity entity) {
    return DoctorModel(
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      image: entity.image,
      specialty: entity.specialty,
      medicalLicense: entity.medicalLicense,
      password: entity.password,
      bioAr: entity.bioAr,
      bioEn: entity.bioEn,
      isVerified: entity.isVerified,
      isRegistered: entity.isRegistered,
      education: entity.education != null
          ? EducationModel.fromEntity(entity.education!)
          : null,
      specialtyData: entity.specialtyData != null
          ? SpecialtyModel.fromEntity(entity.specialtyData!)
          : null,
      files: entity.files,
    );
  }
}
