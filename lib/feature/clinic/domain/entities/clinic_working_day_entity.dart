import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

class ClinicWorkingDayEntity {
  final int? id;
  bool? isSelected;
  final ClinicDayEntity? clinicDayEntity;
  final ClinicShiftEntity? clinicShiftEntity;

  ClinicWorkingDayEntity({
    this.id,
    this.isSelected,
    required this.clinicDayEntity,
    this.clinicShiftEntity,
  });
}
