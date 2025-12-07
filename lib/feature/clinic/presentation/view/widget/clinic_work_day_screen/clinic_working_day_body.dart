import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_work_day_screen/clinic_working_day_button_states.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_work_day_screen/clinic_working_day_item.dart';

class ClinicWorkingDayBody extends StatelessWidget {
  const ClinicWorkingDayBody({super.key, required this.days});
  final List<ClinicDayEntity> days;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: List.generate(
            days.length,
            (index) => ClinicWorkingDayItem(
              text: days[index].dayEn,
            ),
          ),
        ),
        const Spacer(),
        const ClinicWorkDayButtonStates(),
        25.hBox
      ],
    );
  }
}
