import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';

class ClinicDayModel extends ClinicDayEntity {
  ClinicDayModel({
    required super.id,
    required super.dayAr,
    required super.dayEn,
  });

  factory ClinicDayModel.fromJson(Map<String, dynamic> json) {
    return ClinicDayModel(
      id: json['id'],
      dayAr: json['day_ar'],
      dayEn: json['day_en'],
    );
  }
}

extension ClinicDayMapper on ClinicDayModel {
  ClinicDayEntity toEntity() {
    return ClinicDayEntity(
      id: id,
      dayAr: dayAr,
      dayEn: dayEn,
    );
  }
}
