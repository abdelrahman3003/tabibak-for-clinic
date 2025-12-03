import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/feature/clinic/widget/clinic_working_day_item.dart';

class ClinicDaysScreen extends StatelessWidget {
  const ClinicDaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> days = const [
      "Saturday",
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday"
    ];

    return Scaffold(
      appBar: const AppBarWidget(
        title: "Clinic Working Days",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
        child: Column(
          children: [
            Column(
              children: List.generate(
                days.length,
                (index) => ClinicWorkingDayItem(
                  text: days[index],
                ),
              ),
            ),
            const Spacer(),
            AppButton(
              title: "Continue",
              onPressed: () {},
            ),
            25.hBox
          ],
        ),
      ),
    );
  }
}
