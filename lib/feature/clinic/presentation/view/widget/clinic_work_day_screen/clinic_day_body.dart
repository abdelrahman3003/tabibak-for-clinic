import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/app_snack_bar.dart';
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
            (index) {
              final day = widget.days[index];
              return ClinicWorkingDayItem(
                text: day.clinicDayEntity?.dayEn?.tr() ?? "",
                value: day.isSelected ?? false,
                onChanged: (value) {
                  day.isSelected = value;
                  if (value) {
                    if (!selectedDays.contains(day)) {
                      selectedDays.add(day);
                    }
                  } else {
                    selectedDays.remove(day);
                  }
                },
              );
            },
          ),
        ),
        const Spacer(),
        AppButton(
          title: AppString.continueButton,
          onPressed: () {
            if (selectedDays.isEmpty) {
              AppSnackBar.show(
                context: context,
                message: AppString.selectWorkingDays,
              );
              return;
            }
            context.pushNamed(
              Routes.clinicShiftsTimeScreen,
              arguments: ClinicWorkingDayArgs(
                selectedDays: selectedDays,
                clinicId: widget.clinicId,
              ),
            );
          },
        ),
        25.hBox
      ],
    );
  }
}
