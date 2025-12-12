import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/schedule_hours_item.dart';

class ScheduleHoursList extends StatelessWidget {
  const ScheduleHoursList({super.key, required this.workingShiftsDays});
  final List<ClinicWorkingDayEntity> workingShiftsDays;

  @override
  Widget build(BuildContext context) {
    final selectedDays =
        workingShiftsDays.where((e) => e.isSelected ?? false).toList();

    return ListView.builder(
      itemCount: selectedDays.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final workingShiftDay = selectedDays[index];
        return ScheduleHoursItem(workingShiftDay: workingShiftDay);
      },
    );
  }
}
