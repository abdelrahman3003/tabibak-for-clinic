import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/shift_day_time.dart';

class ClinicShiftsTimeScreen extends StatelessWidget {
  const ClinicShiftsTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: "Shift Times",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShiftDayTime(),
            const ShiftDayTime(),
            const Spacer(),
            AppButton(
              title: "Save",
              onPressed: () {
                context.pushNamedAndRemoveUntil(
                  Routes.layOutScreen,
                  (_) => false,
                );
              },
            ),
            20.hBox
          ],
        ),
      ),
    );
  }
}
