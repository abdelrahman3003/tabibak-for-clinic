import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_subtitle_text.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/clinic_schedule.dart';

class WorkDaySection extends StatelessWidget {
  const WorkDaySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthSubtitleText(title: AppString.clinicWorkingDaysAndTime),
        10.hBox,
        const ClinicScheduleWidget(
            //       onScheduleChanged: onScheduleChanged,
            ),
      ],
    );
  }
}
