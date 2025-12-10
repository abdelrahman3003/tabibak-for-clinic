import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_shift_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';

class ClinicWorkingDayModel extends ClinicWorkingDayEntity {
  ClinicWorkingDayModel({
    required super.clinicDayEntity,
    required super.clinicShiftEntity,
  });
  factory ClinicWorkingDayModel.fromJson(Map<String, dynamic> json) {
    return ClinicWorkingDayModel(
      clinicDayEntity: ClinicDayModel.fromJson(json['days']),
      clinicShiftEntity: ClinicShiftModel.fromJson(json['shifts']),
    );
  }
}
