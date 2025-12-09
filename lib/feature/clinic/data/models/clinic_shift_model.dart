import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

class ClinicShiftModel extends ClinicShiftEntity {
  ClinicShiftModel({
    required super.morning,
    required super.evening,
  });

  factory ClinicShiftModel.fromJson(Map<String, dynamic> json) {
    return ClinicShiftModel(
      morning: json["morning"],
      evening: json["evening"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "morning": morning,
      "evening": evening,
    };
  }
}

extension ClinicShiftMapper on ClinicShiftEntity {
  ClinicShiftModel toModel() {
    return ClinicShiftModel(
      morning: morning,
      evening: evening,
    );
  }
}
