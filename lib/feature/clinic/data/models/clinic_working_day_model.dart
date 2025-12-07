import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';

class ClinicWorkingDayModel extends ClinicWorkingDayEntity {
  ClinicWorkingDayModel({
    required super.clinicId,
    required super.day,
  });
  factory ClinicWorkingDayModel.fromJson(Map<String, dynamic> json) {
    return ClinicWorkingDayModel(
      clinicId: json["clinic_id"],
      day: json["day"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "clinic_id": clinicId,
      "day": day,
    };
  }
}

extension ClinicWorkingDayMapper on ClinicWorkingDayEntity {
  ClinicWorkingDayModel toModel() {
    return ClinicWorkingDayModel(
      clinicId: clinicId,
      day: day,
    );
  }
}
