import 'package:tabibak_for_clinic/feature/auth/domain/entities/shift_entity.dart';

class ShiftModel extends ShiftEntity {
  final int workingDayId;
  const ShiftModel({
    required this.workingDayId,
    required super.morning,
    required super.evening,
  });
  Map<String, dynamic> toJson() {
    return {
      "evening": morning,
      "morning": evening,
      "working_day_id": workingDayId,
    };
  }
}
