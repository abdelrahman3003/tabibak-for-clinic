import 'package:tabibak_for_clinic/feature/auth/domain/entities/doctor_entity.dart';

class DotcorModel extends DoctorEntity {
  final String password;
  const DotcorModel({
    required super.name,
    required super.phone,
    required super.image,
    required super.specialty,
    required super.medicalLiecense,
    required super.email,
    required this.password,
  });
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "email": email,
      "image": image,
      "specialty": specialty,
      "medical_liecense": medicalLiecense,
    };
  }
}
