import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';

class ClinicWorkingDayArgs {
  final List<ClinicWorkingDayEntity> selectedDays;
  final int clinicId;

  ClinicWorkingDayArgs({
    required this.selectedDays,
    required this.clinicId,
  });
}
