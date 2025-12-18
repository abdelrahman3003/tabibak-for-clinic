import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_file_entity.dart';

class DoctorFileModel extends DoctorFileEntity {
  const DoctorFileModel({required super.id, required super.fileUrl});
  factory DoctorFileModel.fromJson(Map<String, dynamic> json) {
    return DoctorFileModel(id: json['id'], fileUrl: json['file']);
  }
  Map<String, dynamic> toJson() {
    return {
      "file": fileUrl,
    };
  }
}
