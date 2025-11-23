import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/feature/schedule/widget/schedule_screen/schedule_hours_list/schedule_hours_item.dart';

import '../../../schedule_edit_screen.dart';

class ScheduleHoursList extends StatelessWidget {
  const ScheduleHoursList({super.key});
  // final List<DaySchedule> scheduleHoursItemList;
  @override
  Widget build(BuildContext context) {
    final List<DaySchedule> scheduleHoursItemList = [
      DaySchedule(
        day: "Monday",
        morning: Shift(
          name: "Morning",
          start: TimeOfDay(hour: 8, minute: 0),
          end: TimeOfDay(hour: 12, minute: 0),
        ),
        evening: Shift(
          name: "Evening",
          start: TimeOfDay(hour: 16, minute: 0),
          end: TimeOfDay(hour: 20, minute: 0),
        ),
      ),
      DaySchedule(
        day: "Tuesday",
        morning: Shift(
          name: "Morning",
          start: TimeOfDay(hour: 8, minute: 0),
          end: TimeOfDay(hour: 12, minute: 0),
        ),
        evening: Shift(
          name: "Evening",
          start: TimeOfDay(hour: 16, minute: 0),
          end: TimeOfDay(hour: 20, minute: 0),
        ),
      ),
      DaySchedule(
        day: "Wednesday",
        morning: Shift(
          name: "Morning",
          start: TimeOfDay(hour: 8, minute: 0),
          end: TimeOfDay(hour: 12, minute: 0),
        ),
        evening: Shift(
          name: "Evening",
          start: TimeOfDay(hour: 16, minute: 0),
          end: TimeOfDay(hour: 20, minute: 0),
        ),
      ),
      DaySchedule(
        day: "Thursday",
        morning: Shift(
          name: "Morning",
          start: TimeOfDay(hour: 8, minute: 0),
          end: TimeOfDay(hour: 12, minute: 0),
        ),
        evening: Shift(
          name: "Evening",
          start: TimeOfDay(hour: 16, minute: 0),
          end: TimeOfDay(hour: 20, minute: 0),
        ),
      ),
      DaySchedule(
        day: "Friday",
        morning: Shift(
          name: "Morning",
          start: TimeOfDay(hour: 8, minute: 0),
          end: TimeOfDay(hour: 12, minute: 0),
        ),
        evening: Shift(
          name: "Evening",
          start: TimeOfDay(hour: 16, minute: 0),
          end: TimeOfDay(hour: 20, minute: 0),
        ),
      ),
      DaySchedule(
        day: "Saturday",
        morning: Shift(
          name: "Morning",
          start: TimeOfDay(hour: 8, minute: 0),
          end: TimeOfDay(hour: 12, minute: 0),
        ),
        evening: Shift(
          name: "Evening",
          start: TimeOfDay(hour: 16, minute: 0),
          end: TimeOfDay(hour: 20, minute: 0),
        ),
      ),
      DaySchedule(
        day: "Sunday",
        morning: Shift(
          name: "Morning",
          start: TimeOfDay(hour: 8, minute: 0),
          end: TimeOfDay(hour: 12, minute: 0),
        ),
        evening: Shift(
          name: "Evening",
          start: TimeOfDay(hour: 16, minute: 0),
          end: TimeOfDay(hour: 20, minute: 0),
        ),
      ),
    ];

    return ListView.builder(
      itemCount: scheduleHoursItemList.length,
      itemBuilder: (context, index) {
        final day = scheduleHoursItemList[index];
        return ScheduleHoursItem(day: day);
      },
    );
  }
}
