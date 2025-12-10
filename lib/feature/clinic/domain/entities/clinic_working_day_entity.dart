import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

class ClinicWorkingDayEntity {
  final ClinicDayEntity clinicDayEntity;
  final ClinicShiftEntity clinicShiftEntity;

  ClinicWorkingDayEntity({
    required this.clinicDayEntity,
    required this.clinicShiftEntity,
  });
}
