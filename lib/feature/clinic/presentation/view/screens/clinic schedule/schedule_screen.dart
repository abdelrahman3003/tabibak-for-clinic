import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/clinic_header.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/clinic_info_section.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/clinic_schedule_section.dart';

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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  15.hBox,
                  const ClinicInfoSection(),
                  20.hBox,
                  const ClinicScheduleSection()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
