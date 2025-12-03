import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';

class ClinicStructureScreen extends StatelessWidget {
  const ClinicStructureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(title: "Create Clinic"),
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
          child: Column(
            children: [
              const TextFormFiledWidget(label: "Clinic Name"),
              const TextFormFiledWidget(
                  label: "Phone Number", keyboardType: TextInputType.number),
              const TextFormFiledWidget(
                label: "Consultation Fee",
                keyboardType: TextInputType.number,
                suffixText: "EGY",
              ),
              const Spacer(),
              AppButton(
                title: "Continue",
                onPressed: () {
                  context.pushNamed(Routes.clinicDaysScreen);
                },
              ),
              25.hBox,
            ],
          ),
        ));
  }
}
