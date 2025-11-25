import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';

class ScheduleHoursItem extends StatelessWidget {
  const ScheduleHoursItem({super.key, required this.day});
  final DaySchedule day;

  @override
  Widget build(BuildContext context) {
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
              child: Text(day.day,
                  style: Theme.of(context).textTheme.titleMedium)),
          20.wBox,
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: FittedBox(
                    child: Text(
                        "${day.morning.start.format(context)} - ${day.morning.end.format(context)}",
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
                20.wBox,
                Expanded(
                  child: FittedBox(
                    child: Text(
                      "${day.evening.start.format(context)} - ${day.evening.end.format(context)}",
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.clip,
                    ),
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

class Shift {
  String name;
  TimeOfDay start;
  TimeOfDay end;
  bool enabled;

  Shift({
    required this.name,
    required this.start,
    required this.end,
    this.enabled = true,
  });
}

class DaySchedule {
  String day;
  Shift morning;
  Shift evening;
  bool active;

  DaySchedule({
    required this.day,
    required this.morning,
    required this.evening,
    this.active = true,
  });
}
