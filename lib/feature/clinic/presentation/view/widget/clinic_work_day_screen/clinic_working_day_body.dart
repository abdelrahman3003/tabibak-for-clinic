import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_work_day_screen/clinic_working_day_args.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_work_day_screen/clinic_working_day_item.dart';

class ClinicWorkingDayBody extends StatelessWidget {
  const ClinicWorkingDayBody(
      {super.key, required this.days, required this.clinicId});
  final List<ClinicDayEntity> days;
  final int clinicId;
  @override
  Widget build(BuildContext context) {
    final List<ClinicDayEntity> selectedDays = [];
    return Column(
      children: [
        Column(
          children: List.generate(
            days.length,
            (index) => ClinicWorkingDayItem(
              text: days[index].dayEn,
              onChanged: (value) {
                if (value) {
                  selectedDays.add(days[index]);
                } else {
                  selectedDays.remove(days[index]);
                }
              },
            ),
          ),
        ),
        const Spacer(),
        AppButton(
          title: "Continue",
          onPressed: () {
            context.pushNamed(
              Routes.clinicShiftsTimeScreen,
              arguments: ClinicWorkingDayArgs(
                  selectedDays: selectedDays, clinicId: clinicId),
            );
          },
        ),
        25.hBox
      ],
    );
  }
}
