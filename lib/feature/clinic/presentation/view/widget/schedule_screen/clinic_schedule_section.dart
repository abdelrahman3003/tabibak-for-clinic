import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/schedule_hours_header.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/schedule_hours_list/schedule_hours_list.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/doctor_profile_screen/profile_title.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/doctor_profile_screen/text_button_widget.dart';

class ClinicScheduleSection extends StatelessWidget {
  const ClinicScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child:
                  ProfileTitle(title: "Schedule", icon: Icons.medical_services),
            ),
            TextButtonWidget(text: "Edit")
          ],
        ),
        15.hBox,
        const ScheduleHoursHeader(),
        const ScheduleHoursList()
      ],
    );
  }
}
