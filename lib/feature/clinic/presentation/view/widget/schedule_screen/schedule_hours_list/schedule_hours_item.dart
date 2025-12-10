import 'dart:developer';

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
    final shift = workingShiftDay.clinicShiftEntity;
    if (shift.evening != null) {
      log("------${shift.evening!.start}");
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 75.w,
              child: Text(workingShiftDay.clinicDayEntity.dayEn,
                  style: Theme.of(context).textTheme.titleMedium)),
          20.wBox,
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                      shift.morning == null
                          ? "--"
                          : "${formatTime(shift.morning!.start)} - ${formatTime(shift.morning!.end)}",
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                20.wBox,
                Expanded(
                  child: Text(
                    shift.evening == null
                        ? "--"
                        : "${formatTime(shift.evening!.start)} - ${formatTime(shift.evening!.end)}",
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
