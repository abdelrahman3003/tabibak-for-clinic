import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';

class ScheduleHoursHeader extends StatelessWidget {
  const ScheduleHoursHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          border: Border.all(color: const Color(0xff94A3B8)),
          color: const Color(0xffF1F5F9)),
      child: Row(
        children: [
          Expanded(child: _buildText(context, AppString.day)),
          Expanded(child: _buildText(context, AppString.morning)),
          Expanded(child: _buildText(context, AppString.evening)),
        ],
      ),
    );
  }

  Text _buildText(BuildContext context, String text) {
    return Text(text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600, color: const Color(0xff94A3B8)));
  }
}
