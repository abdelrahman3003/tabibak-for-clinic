import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
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
      this.initialEnd,
      this.isActive = false,
      this.onChanged});
  final String shift;
  final Function(TimeOfDay)? onStartTimeSelected;
  final Function(TimeOfDay)? onEndTimeSelected;
  final TimeOfDay? initialStart;
  final TimeOfDay? initialEnd;
  final bool isActive;
  final Function(bool)? onChanged;
  @override
  State<ShiftHours> createState() => _ShiftHoursState();
}

class _ShiftHoursState extends State<ShiftHours> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive;
  }

  @override
  void didUpdateWidget(covariant ShiftHours oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      isActive = widget.isActive;
    }
  }

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
                widget.onChanged?.call(value);
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
                    title: AppString.startTime,
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
                  title: AppString.endTime,
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
