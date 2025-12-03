import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

class ClinicShiftModel extends ClinicShiftEntity {
  ClinicShiftModel({
    required super.morning,
    required super.evening,
    required super.workingDayId,
  });

  factory ClinicShiftModel.fromJson(Map<String, dynamic> json) {
    return ClinicShiftModel(
      morning: json["morning"],
      evening: json["evening"],
      workingDayId: json["working_day_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "morning": morning,
      "evening": evening,
      "working_day_id": workingDayId,
    };
  }
}
