import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/schedule_hours_list/schedule_hours_item.dart';

class ScheduleHoursList extends StatelessWidget {
  const ScheduleHoursList({super.key, required this.workingShiftsDays});
  final List<ClinicWorkingDayEntity> workingShiftsDays;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workingShiftsDays.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final workingShiftDay = workingShiftsDays[index];
        return ScheduleHoursItem(workingShiftDay: workingShiftDay);
      },
    );
  }
}
