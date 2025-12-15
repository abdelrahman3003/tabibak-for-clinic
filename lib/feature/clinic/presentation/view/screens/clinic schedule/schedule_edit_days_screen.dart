import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_work_day_screen/clinic_working_day_args.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_work_day_screen/clinic_working_day_item.dart';

class ScheduleEditDaysScreen extends StatefulWidget {
  const ScheduleEditDaysScreen({super.key});

  @override
  State<ScheduleEditDaysScreen> createState() => _ScheduleEditDaysScreenState();
}

class _ScheduleEditDaysScreenState extends State<ScheduleEditDaysScreen> {
  late List<ClinicWorkingDayEntity> days;
  late ClinicWorkingDayArgs args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as ClinicWorkingDayArgs;
    days = List.from(args.selectedDays);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Clinic Working Days"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  return ClinicWorkingDayItem(
                    text: day.clinicDayEntity!.dayEn!,
                    value: day.isSelected ?? false,
                    onChanged: (value) {
                      day.isSelected = value;
                    },
                  );
                },
              ),
            ),
            AppButton(
              title: "Continue",
              onPressed: () {
                final selectedDays =
                    days.where((e) => e.isSelected == true).toList();
                context.pushNamed(
                  Routes.clinicShiftsTimeScreen,
                  arguments: ClinicWorkingDayArgs(
                      selectedDays: selectedDays, clinicId: args.clinicId),
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
