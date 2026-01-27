import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

class ClinicShiftModel extends ClinicShiftEntity {
  ClinicShiftModel({
    super.shiftId,
    super.start,
    super.end,
  });

  factory ClinicShiftModel.fromJson(Map<String, dynamic> json) {
    return ClinicShiftModel(
      shiftId: json['id'],
      start: parseTime(json['start']),
      end: parseTime(json['end']),
    );
  }
}
