import 'package:tabibak_for_clinic/feature/doctor/data/model/education_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/specialty_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';

class DoctorModel extends DoctorEntity {
  const DoctorModel(
      {super.name,
      super.phone,
      super.image,
      super.specialty,
      super.medicalLiecense,
      super.email,
      super.password,
      super.bio,
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
      "medical_liecense": medicalLiecense,
      "bio": bio,
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
      medicalLiecense: json['medical_liecense'] as String,
      bio: json['bio'] as String?,
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
}
