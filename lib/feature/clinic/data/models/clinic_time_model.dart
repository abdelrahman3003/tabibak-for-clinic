import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_time_entity.dart';

class ClinicTimeModel extends ClinicTimeEntity {
  ClinicTimeModel({
    required super.start,
    required super.end,
  });

  factory ClinicTimeModel.fromJson(Map<String, dynamic>? json) {
    return ClinicTimeModel(
      start: parseTime(json?["start"]),
      end: parseTime(json?["end"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "start": formatTime(start),
      "end": formatTime(end),
    };
  }
}
