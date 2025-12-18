import 'package:tabibak_for_clinic/feature/doctor/domain/entities/education_entity.dart';

class EducationModel extends EducationEntity {
  EducationModel({
    super.id,
    super.university,
    super.year,
    super.doctorId,
    super.degree,
    super.country,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json['id'] as int,
      university: json['university'] as String,
      year: json['year'] as int,
      doctorId: json['doctor_id'] as String,
      degree: (json['degree'] as num).toDouble(),
      country: json['country'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university': university,
      'year': year,
      'doctor_id': doctorId,
      'degree': degree,
      'country': country,
    };
  }
}
