import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extenstion/spacing.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/clinic_day_shift.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_subtitle_text.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/clinic_schedule.dart';

class WorkDaySection extends StatelessWidget {
  const WorkDaySection({super.key, required this.onScheduleChanged});
  final void Function(List<WorkDayShift>) onScheduleChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthSubtitleText(title: "Clinic Working Days & Time"),
        10.hBox,
        ClinicScheduleWidget(
          onScheduleChanged: onScheduleChanged,
        ),
      ],
    );
  }
}
