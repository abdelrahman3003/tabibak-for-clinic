import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';

class ScheduleHoursHeader extends StatelessWidget {
  const ScheduleHoursHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
}
