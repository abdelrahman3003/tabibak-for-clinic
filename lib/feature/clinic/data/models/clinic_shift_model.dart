import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

class ClinicShiftModel extends ClinicShiftEntity {
  ClinicShiftModel(
    super.morningStart,
    super.morningEnd,
    super.eveningStart,
    super.eveningEnd,
  );

  factory ClinicShiftModel.fromJson(Map<String, dynamic> json) {
    return ClinicShiftModel(
      parseTime(json['morning_start']),
      parseTime(json['morning_end']),
      parseTime(json['evening_start']),
      parseTime(json['evening_end']),
    );
  }
}
