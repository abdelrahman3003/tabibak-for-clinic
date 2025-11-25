import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/feature/schedule/widget/schedule_edit_screen/shift_hours.dart';

class ScheduleDay extends StatefulWidget {
  const ScheduleDay({super.key, required this.day});
  final String day;
  @override
  State<ScheduleDay> createState() => _ScheduleDayState();
}

bool isActive = false;

class _ScheduleDayState extends State<ScheduleDay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.day,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Transform.scale(
                  scale: .75,
                  child: Switch(
                    value: isActive,
                    onChanged: (value) {
                      isActive = value;
                      setState(() {});
                    },
                  ),
                )
              ],
            ),
            if (isActive)
              const Column(
                children: [
                  ShiftHours(shift: "Morning"),
                  ShiftHours(shift: "Evening"),
                ],
              )
          ],
        ),
      ],
    );
  }
}
