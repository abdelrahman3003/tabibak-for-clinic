import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_work_day_screen/clinic_working_day_args.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/schedule_hours_header.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/schedule_hours_list.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/widget/doctor_profile_screen/profile_title.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/widget/doctor_profile_screen/text_button_widget.dart';

class ClinicScheduleSection extends StatelessWidget {
  const ClinicScheduleSection(
      {super.key, required this.workingShiftsDays, required this.clinicId});
  final List<ClinicWorkingDayEntity> workingShiftsDays;
  final int clinicId;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child:
                  ProfileTitle(title: "Schedule", icon: Icons.medical_services),
            ),
            TextButtonWidget(
              text: "Edit",
              onTap: () {
                context.pushNamed(
                  Routes.scheduleEditDaysScreen,
                  arguments: ClinicWorkingDayArgs(
                      selectedDays: workingShiftsDays, clinicId: clinicId),
                );
              },
            )
          ],
        ),
        15.hBox,
        const ScheduleHoursHeader(),
        ScheduleHoursList(workingShiftsDays: workingShiftsDays)
      ],
    );
  }
}
