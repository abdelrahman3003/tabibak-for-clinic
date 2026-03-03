import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_profile_status_entity.dart';

class DoctorProfileStatusModel extends DoctorProfileStatusEntity {
  DoctorProfileStatusModel({required super.statusEn, required super.statusAr});
  factory DoctorProfileStatusModel.fromJson(Map<String, dynamic> json) {
    return DoctorProfileStatusModel(
      statusAr: json['status_ar'] as String,
      statusEn: json['status_en'] as String,
    );
  }
}
