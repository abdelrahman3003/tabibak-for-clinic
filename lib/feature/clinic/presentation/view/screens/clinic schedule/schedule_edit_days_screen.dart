import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_schedule_argument_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_work_day_screen/clinic_working_day_args.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_work_day_screen/clinic_working_day_item.dart';

class ScheduleEditDaysScreen extends StatelessWidget {
  const ScheduleEditDaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clinicScheduleArgumentModel = ModalRoute.of(context)!
        .settings
        .arguments as ClinicScheduleArgumentModel;
    final List<ClinicWorkingDayEntity> selectedWorkingDays = [];
    final days = clinicScheduleArgumentModel.workingShiftsDays;
    return Scaffold(
      appBar: const AppBarWidget(
        title: "Clinic Working Days",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Column(
              children: List.generate(
                days.length,
                (index) => ClinicWorkingDayItem(
                  text: days[index].clinicDayEntity.dayEn,
                  value: days[index].isSelected ?? false,
                  onChanged: (value) {
                    if (value) {
                      selectedWorkingDays.add(days[index]);
                    } else {
                      selectedWorkingDays.remove(days[index]);
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
                      selectedDays: [],
                      clinicId: clinicScheduleArgumentModel.clinicId),
                );
              },
            ),
            25.hBox,
          ],
        ),
      ),
    );
  }
}
