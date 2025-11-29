import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/doctor_profile_screen/profile_title.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/doctor_profile_screen/text_button_widget.dart';
import 'package:tabibak_for_clinic/feature/schedule/widget/schedule_screen/clinic_header.dart';
import 'package:tabibak_for_clinic/feature/schedule/widget/schedule_screen/clinic_info_section.dart';
import 'package:tabibak_for_clinic/feature/schedule/widget/schedule_screen/schedule_hours_header.dart';
import 'package:tabibak_for_clinic/feature/schedule/widget/schedule_screen/schedule_hours_list/schedule_hours_list.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ClinicHeader(),
          5.hBox,
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    15.hBox,
                    const ProfileTitle(
                        title: "Clinic Information",
                        icon: Icons.medical_services),
                    15.hBox,
                    const ClinicInfoSection(),
                    20.hBox,
                    const Row(
                      children: [
                        Expanded(
                          child: ProfileTitle(
                              title: "Schedule", icon: Icons.medical_services),
                        ),
                        TextButtonWidget(text: "Edit")
                      ],
                    ),
                    15.hBox,
                    const ScheduleHoursHeader(),
                    const ScheduleHoursList()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
