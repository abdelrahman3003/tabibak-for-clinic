import 'package:tabibak_for_clinic/feature/auth/domain/entities/doctor_entity.dart';

class DotcorModel extends DoctorEntity {
  const DotcorModel({
    required super.name,
    required super.phone,
    required super.image,
    required super.specialty,
    required super.bio,
    required super.nationalId,
    required super.medicalLiecense,
  });
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "image": image,
      "bio": bio,
      "specialty": specialty,
      "national_id": nationalId,
      "medical_liecense": medicalLiecense,
    };
  }
}
