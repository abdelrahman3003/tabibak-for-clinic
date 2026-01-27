import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_shift_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';

class ClinicWorkingDayModel extends ClinicWorkingDayEntity {
  ClinicWorkingDayModel({
    super.id,
    super.isSelected,
    required super.clinicDayEntity,
    super.clinicShiftMorningEntity,
    super.clinicShiftEveningEntity,
  });

  factory ClinicWorkingDayModel.fromJson(Map<String, dynamic> json) {
    return ClinicWorkingDayModel(
      id: json['id'],
      isSelected: json['is_selected'] ?? false,
      clinicDayEntity: ClinicDayModel.fromJson(json['days']),
      clinicShiftMorningEntity: json['shifts_morning'] != null
          ? ClinicShiftModel.fromJson(json['shifts_morning'])
          : null,
      clinicShiftEveningEntity: json['shift_evening'] != null
          ? ClinicShiftModel.fromJson(json['shift_evening'])
          : null,
    );
  }
}
