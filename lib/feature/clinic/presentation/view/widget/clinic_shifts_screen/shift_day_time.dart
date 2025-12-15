import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_edit_screen/shift_hours.dart';

class ShiftDayTime extends StatelessWidget {
  const ShiftDayTime({
    super.key,
    required this.day,
    this.onStarMorningSelected,
    this.onEndMorningSelected,
    this.onStartEveningSelected,
    this.onEndEveningSelected,
    this.initialMorningStart,
    this.initialMorningEnd,
    this.initialEveningStart,
    this.initialEveningEnd,
  });
  final ClinicDayEntity day;
  final Function(TimeOfDay)? onStarMorningSelected;
  final Function(TimeOfDay)? onEndMorningSelected;
  final Function(TimeOfDay)? onStartEveningSelected;
  final Function(TimeOfDay)? onEndEveningSelected;
  final TimeOfDay? initialMorningStart;
  final TimeOfDay? initialMorningEnd;
  final TimeOfDay? initialEveningStart;
  final TimeOfDay? initialEveningEnd;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day.dayEn!,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          ShiftHours(
            shift: "Morning",
            onStartTimeSelected: onStarMorningSelected,
            onEndTimeSelected: onEndMorningSelected,
            initialEnd: initialMorningStart,
            initialStart: initialMorningEnd,
          ),
          ShiftHours(
            shift: "Evening",
            onStartTimeSelected: onStartEveningSelected,
            onEndTimeSelected: onEndEveningSelected,
            initialStart: initialEveningStart,
            initialEnd: initialEveningEnd,
          ),
        ],
      ),
    );
  }
}
