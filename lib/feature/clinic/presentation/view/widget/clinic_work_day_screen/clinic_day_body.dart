import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_working_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_work_day_screen/clinic_working_day_args.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_work_day_screen/clinic_working_day_item.dart';

class ClinicDayBody extends StatefulWidget {
  const ClinicDayBody({super.key, required this.days, required this.clinicId});
  final List<ClinicWorkingDayModel> days;
  final int clinicId;

  @override
  State<ClinicDayBody> createState() => _ClinicDayBodyState();
}

class _ClinicDayBodyState extends State<ClinicDayBody> {
  final List<ClinicWorkingDayModel> selectedDays = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: List.generate(
            widget.days.length,
            (index) => ClinicWorkingDayItem(
              text: widget.days[index].clinicDayEntity!.dayEn!,
              onChanged: (value) {
                if (value) {
                  selectedDays.add(widget.days[index]);
                } else {
                  selectedDays.remove(widget.days[index]);
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
                  selectedDays: selectedDays, clinicId: widget.clinicId),
            );
          },
        ),
        25.hBox
      ],
    );
  }
}
