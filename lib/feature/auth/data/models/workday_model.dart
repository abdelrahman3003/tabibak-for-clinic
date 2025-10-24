import 'package:tabibak_for_clinic/feature/auth/domain/entities/work_day_entity.dart';

class WorkingDayModel extends WorkDayEntity {
  final int clinicId;
  const WorkingDayModel({
    required super.day,
    required this.clinicId,
  });

  Map<String, dynamic> toJson() => {
        "day": day,
        "clinic_id": clinicId,
      };
}
