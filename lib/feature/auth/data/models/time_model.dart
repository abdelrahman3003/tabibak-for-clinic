import 'package:tabibak_for_clinic/feature/auth/domain/entities/time_entity.dart';

class TimeModel extends TimeEntity {
  const TimeModel({required super.start, required super.end});
  Map<String, dynamic> toJson() {
    return {
      "start": start,
      "end": end,
    };
  }
}
