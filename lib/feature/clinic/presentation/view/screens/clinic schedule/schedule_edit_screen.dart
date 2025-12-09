import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_edit_screen/schedule_day.dart';

class ScheduleEditScreen extends StatelessWidget {
  const ScheduleEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: AppBarWidget(
          title: "Edit Schedule",
        ),
        body: Padding(
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
