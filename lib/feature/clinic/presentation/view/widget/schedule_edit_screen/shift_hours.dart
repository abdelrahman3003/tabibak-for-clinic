import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_edit_screen/custom_switch.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_edit_screen/time_field.dart';

class ShiftHours extends StatefulWidget {
  const ShiftHours(
      {super.key,
      required this.shift,
      this.onStartTimeSelected,
      this.onEndTimeSelected,
      this.initialStart,
      this.initialEnd});
  final String shift;
  final Function(TimeOfDay)? onStartTimeSelected;
  final Function(TimeOfDay)? onEndTimeSelected;
  final TimeOfDay? initialStart;
  final TimeOfDay? initialEnd;
  @override
  State<ShiftHours> createState() => _ShiftHoursState();
}

class _ShiftHoursState extends State<ShiftHours> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.shift,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isActive ? AppColors.black : const Color(0xff334155),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w400),
            ),
            const Spacer(),
            CustomSwitch(
              value: isActive,
              onChanged: (value) {
                isActive = value;
                setState(() {});
              },
            )
          ],
        ),
        18.hBox,
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TimeField(
                    title: "Start Time",
                    onTimeSelected: widget.onStartTimeSelected,
                    enable: isActive,
                    value: widget.initialStart,
                  ),
                ],
              ),
            ),
            30.wBox,
            Expanded(
                child: Column(
              children: [
                TimeField(
                  title: "End Time",
                  onTimeSelected: widget.onEndTimeSelected,
                  enable: isActive,
                  value: widget.initialEnd,
                ),
              ],
            )),
          ],
        ),
      ],
    );
  }
}
