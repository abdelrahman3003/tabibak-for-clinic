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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF1F5F9),
        border: const Border(
          bottom: BorderSide(color: Color(0xff94A3B8)),
          left: BorderSide(color: Color(0xffCBD5E1)),
          right: BorderSide(color: Color(0xffCBD5E1)),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff64748B).withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.builder(
        itemCount: selectedDays.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final workingShiftDay = selectedDays[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ScheduleHoursItem(workingShiftDay: workingShiftDay),
          );
        },
      ),
    );
  }
}
