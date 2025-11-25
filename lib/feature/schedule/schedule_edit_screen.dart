import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/schedule/widget/schedule_edit_screen/schedule_day.dart';

class ScheduleEditScreen extends StatelessWidget {
  const ScheduleEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Schedule'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Save",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColors.primary),
              ),
            )
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScheduleDay(day: "Saturday"),
                ScheduleDay(day: "Sunday"),
                ScheduleDay(day: "Monday"),
                ScheduleDay(day: "Tuesday"),
                ScheduleDay(day: "Wednesday"),
                ScheduleDay(day: "Thursday"),
                ScheduleDay(day: "Friday"),
              ],
            ),
          ),
        ));
  }
}
