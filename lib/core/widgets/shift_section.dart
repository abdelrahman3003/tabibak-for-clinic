import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/time_button.dart';

class ShiftSection extends StatelessWidget {
  const ShiftSection(
      {super.key,
      required this.title,
      this.start,
      this.end,
      required this.onStartTap,
      required this.onEndTap});
  final String title;
  final TimeOfDay? start;
  final TimeOfDay? end;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyLarge),
        4.hBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TimeButton(title: 'From', time: start, onTap: onStartTap),
            TimeButton(title: 'To', time: end, onTap: onEndTap),
          ],
        ),
      ],
    );
  }
}
