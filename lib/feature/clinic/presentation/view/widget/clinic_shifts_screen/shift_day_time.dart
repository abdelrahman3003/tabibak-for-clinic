import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/feature/schedule/widget/schedule_edit_screen/shift_hours.dart';

class ShiftDayTime extends StatelessWidget {
  const ShiftDayTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Saturday",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const ShiftHours(shift: "Morning"),
          const ShiftHours(shift: "Evening"),
        ],
      ),
    );
  }
}
