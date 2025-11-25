import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/schedule/widget/schedule_edit_screen/time_field.dart';

class ShiftHours extends StatefulWidget {
  const ShiftHours({super.key, required this.shift});
  final String shift;

  @override
  State<ShiftHours> createState() => _ShiftHoursState();
}

bool isActive = false;

class _ShiftHoursState extends State<ShiftHours> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.shift,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.black : AppColors.grey),
            ),
            const Spacer(),
            Checkbox(
              value: isActive,
              onChanged: (value) {
                isActive = value!;
                setState(() {});
              },
            )
          ],
        ),
        Row(
          children: [
            Expanded(
                child: TimeField(
              onTimeSelected: (time) {},
              enable: isActive,
              value: "6:00 PM",
            )),
            30.wBox,
            Expanded(
                child: TimeField(
              onTimeSelected: (time) {},
              enable: isActive,
              value: "9:00 PM",
            )),
          ],
        ),
      ],
    );
  }
}
