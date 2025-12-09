import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_edit_screen/time_field.dart';

class ShiftHours extends StatefulWidget {
  const ShiftHours(
      {super.key,
      required this.shift,
      this.onStartTimeSelected,
      this.onEndTimeSelected});
  final String shift;
  final Function(TimeOfDay)? onStartTimeSelected;
  final Function(TimeOfDay)? onEndTimeSelected;
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
              onTimeSelected: widget.onStartTimeSelected,
              enable: isActive,
              value: "Select Time",
            )),
            30.wBox,
            Expanded(
                child: TimeField(
              onTimeSelected: widget.onEndTimeSelected,
              enable: isActive,
              value: "Select Time",
            )),
          ],
        ),
      ],
    );
  }
}
