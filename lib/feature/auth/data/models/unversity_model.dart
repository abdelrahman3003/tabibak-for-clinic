import 'package:tabibak_for_clinic/feature/auth/domain/entities/university_entity.dart';

class UnversityModel extends UniversityEntity {
  final int doctorId;
  const UnversityModel(
      {required this.doctorId,
      required super.universityName,
      required super.graduationYear});

  Map<String, dynamic> toJson() {
    return {
      "doctor_id": doctorId,
      "university_name": universityName,
      "graduation_year": graduationYear
    };
  }
}
