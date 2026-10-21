import 'package:tabibak_for_clinic/feature/clinic/domain/entities/doctor_service_entity.dart';

class DoctorServiceModel extends DoctorServiceEntity {
  const DoctorServiceModel({
    super.id,
    super.doctorId,
    super.clinicId,
    required super.name,
    super.createdAt,
    super.updatedAt,
  });

  factory DoctorServiceModel.fromJson(Map<String, dynamic> json) {
    return DoctorServiceModel(
      id: json['id'] as int?,
      doctorId: json['doctor_id'] as String?,
      clinicId: json['clinic_id'] as int?,
      name: (json['name'] as String?) ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'clinic_id': clinicId,
    };
    if (id != null && id! > 0) {
      map['id'] = id;
    }
    if (doctorId != null && doctorId!.isNotEmpty) {
      map['doctor_id'] = doctorId;
    }
    return map;
  }

  factory DoctorServiceModel.fromEntity(DoctorServiceEntity entity) {
    return DoctorServiceModel(
      id: entity.id,
      doctorId: entity.doctorId,
      clinicId: entity.clinicId,
      name: entity.name,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  DoctorServiceEntity toEntity() {
    return DoctorServiceEntity(
      id: id,
      doctorId: doctorId,
      clinicId: clinicId,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
