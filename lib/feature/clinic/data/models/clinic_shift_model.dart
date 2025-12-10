import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_time_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

class ClinicShiftModel extends ClinicShiftEntity {
  ClinicShiftModel({
    required super.morning,
    required super.evening,
  });

  factory ClinicShiftModel.fromJson(Map<String, dynamic> json) {
    return ClinicShiftModel(
      morning: json["morning"] != null
          ? ClinicTimeModel.fromJson(json["morning"])
          : null,
      evening: json["evening"] != null
          ? ClinicTimeModel.fromJson(json["evening"])
          : null,
    );
  }
}
