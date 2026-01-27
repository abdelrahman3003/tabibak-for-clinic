import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';

class ScheduleHoursItem extends StatelessWidget {
  const ScheduleHoursItem({super.key, required this.workingShiftDay});
  final ClinicWorkingDayEntity workingShiftDay;

  @override
  Widget build(BuildContext context) {
    final shiftMorning = workingShiftDay.clinicShiftMorningEntity;
    final shiftEvening = workingShiftDay.clinicShiftEveningEntity;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 75.w,
            child: Text(workingShiftDay.clinicDayEntity!.dayEn!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff334155)))),
        20.wBox,
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: shiftMorning?.start == null
                    ? _buildHourText("--", context)
                    : Column(
                        children: [
                          _buildHourText(
                              "${formatTime(shiftMorning?.start)}", context),
                          _buildHourText(
                              "${formatTime(shiftMorning?.end)}", context),
                        ],
                      ),
              ),
              20.wBox,
              Expanded(
                child: shiftEvening?.start == null
                    ? _buildHourText("--", context)
                    : Column(
                        children: [
                          _buildHourText(
                              "${formatTime(shiftEvening?.start)}", context),
                          _buildHourText(
                              "${formatTime(shiftEvening?.end)}", context),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Text _buildHourText(String text, BuildContext context) {
    return Text(text,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: const Color(0xff475569)));
  }
}
