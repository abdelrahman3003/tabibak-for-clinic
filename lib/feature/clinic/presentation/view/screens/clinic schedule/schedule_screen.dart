import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/clinic_header.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/clinic_info_section.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/clinic_schedule_section.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen(
      {super.key,
      required this.clinicInfoEntity,
      required this.workingShiftsDays});
  final ClinicInfoEntity clinicInfoEntity;
  final List<ClinicWorkingDayEntity> workingShiftsDays;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClinicHeader(
              clinicName: clinicInfoEntity.clinicName ?? "",
              clinicAddress:
                  clinicInfoEntity.address ?? "Address is't available"),
          5.hBox,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  15.hBox,
                  ClinicInfoSection(clinicInfoEntity: clinicInfoEntity),
                  20.hBox,
                  ClinicScheduleSection(
                      workingShiftsDays: workingShiftsDays,
                      clinicId: clinicInfoEntity.id!)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
