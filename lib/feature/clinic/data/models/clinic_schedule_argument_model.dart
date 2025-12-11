import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';

class ClinicScheduleArgumentModel {
  final List<ClinicWorkingDayEntity> workingShiftsDays;
  final int clinicId;

  ClinicScheduleArgumentModel(
      {required this.workingShiftsDays, required this.clinicId});
}
