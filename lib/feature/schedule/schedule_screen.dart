import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constatnt/app_string.dart';
import 'package:tabibak_for_clinic/core/extenstion/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/schedule/widget/schedule_screen/schedule_hours_list/schedule_hours_list.dart';
import 'package:tabibak_for_clinic/feature/schedule/widget/schedule_screen/title_text.dart';

import 'schedule_edit_screen.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleText(title: AppString.weeklyOverview),
            10.hBox,
            _buildSectionHeader(context),
            20.hBox,
            _buildHoursHeader(context),
            5.hBox,
            _buildScheduleHeader(context),
            const Expanded(child: ScheduleHoursList()),
          ],
        ),
      ),
    );
  }

  Row _buildHoursHeader(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: TitleText(title: AppString.scheduleHours)),
        IconButton(
            onPressed: () {},
            icon: Text(
              "Edit",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.primary),
            ))
      ],
    );
  }

  Widget buildRow(BuildContext context, DaySchedule day) {
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
              width: 60.w,
              child:
                  Text(day.day, style: Theme.of(context).textTheme.bodyLarge)),
          20.wBox,
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                      "${day.morning.start.format(context)} - ${day.morning.end.format(context)}",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                20.wBox,
                Expanded(
                  child: Text(
                    "${day.evening.start.format(context)} - ${day.evening.end.format(context)}",
                    style: Theme.of(context).textTheme.bodyLarge,
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

  Widget _buildScheduleHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(AppString.day,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 3,
          child: Text(AppString.morning,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 3,
          child: Text(AppString.evening,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppString.weeklyDays(5),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          AppString.weeklyShiftHours("8:00", "12:00", "16:00 ", "20:00"),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
