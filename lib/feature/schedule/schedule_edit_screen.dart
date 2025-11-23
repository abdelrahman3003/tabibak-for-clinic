import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ScheduleEditScreen extends StatefulWidget {
  const ScheduleEditScreen({super.key});

  @override
  State<ScheduleEditScreen> createState() => _ScheduleScreenState();
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

class _ScheduleScreenState extends State<ScheduleEditScreen> {
  List<DaySchedule> weekSchedule = [];

  @override
  void initState() {
    super.initState();

    final days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];

    weekSchedule = days
        .map((day) => DaySchedule(
              day: day,
              morning: Shift(
                  name: "Morning",
                  start: TimeOfDay(hour: 8, minute: 0),
                  end: TimeOfDay(hour: 12, minute: 0)),
              evening: Shift(
                  name: "Evening",
                  start: TimeOfDay(hour: 16, minute: 0),
                  end: TimeOfDay(hour: 20, minute: 0)),
            ))
        .toList();
  }

  Future<void> pickTime(Shift shift, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? shift.start : shift.end,
    );
    if (picked != null) {
      setState(() {
        if (isStart)
          shift.start = picked;
        else
          shift.end = picked;
      });
    }
  }

  Widget buildShiftWidget(Shift shift) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () async {
          if (!shift.enabled) return;
          await pickTime(shift, true);
        },
        onLongPress: () async {
          if (!shift.enabled) return;
          await pickTime(shift, false);
        },
        child: Container(
          decoration: BoxDecoration(
            color: shift.enabled
                ? AppColors.primary.withOpacity(0.15)
                : Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(shift.name,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: shift.enabled ? AppColors.primary : Colors.grey)),
              Row(
                children: [
                  Text(
                      "${shift.start.format(context)} - ${shift.end.format(context)}",
                      style: TextStyle(
                          color:
                              shift.enabled ? AppColors.primary : Colors.grey)),
                  const SizedBox(width: 12),
                  Switch(
                    value: shift.enabled,
                    onChanged: (val) {
                      setState(() {
                        shift.enabled = val;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: weekSchedule.length,
        itemBuilder: (context, index) {
          final daySchedule = weekSchedule[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم اليوم مع مفتاح التفعيل
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(daySchedule.day,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Switch(
                        value: daySchedule.active,
                        onChanged: (val) {
                          setState(() {
                            daySchedule.active = val;
                            daySchedule.morning.enabled = val;
                            daySchedule.evening.enabled = val;
                          });
                        },
                        activeColor: AppColors.primary,
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  // هنا نعرض الـ Shifts فقط إذا كان اليوم مفعل
                  if (daySchedule.active) ...[
                    buildShiftWidget(daySchedule.morning),
                    buildShiftWidget(daySchedule.evening),
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
