import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';

class ClinicWorkingDayArgs {
  final List<ClinicDayEntity> selectedDays;
  final int clinicId;

  ClinicWorkingDayArgs({
    required this.selectedDays,
    required this.clinicId,
  });
}
