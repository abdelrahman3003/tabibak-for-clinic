import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/feature/schedule/widget/schedule_screen/schedule_hours_list/schedule_hours_list.dart';
import 'package:tabibak_for_clinic/feature/schedule/widget/schedule_screen/schedule_hours_list/title_text_row.dart';
import 'package:tabibak_for_clinic/feature/schedule/widget/schedule_screen/title_text.dart';

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
            TitleTextRow(
              title: "Schedule Hours",
              subtitle: "Edit",
              onTap: () {
                context.pushNamed(Routes.scheduleEditScreen);
              },
            ),
            10.hBox,
            _buildScheduleHeader(context),
            const Expanded(child: ScheduleHoursList()),
          ],
        ),
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
