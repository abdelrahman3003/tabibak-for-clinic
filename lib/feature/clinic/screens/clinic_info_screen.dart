import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/doctor_personal_info_screen/app_bar_save.dart';

class ClinicInfoScreen extends StatelessWidget {
  const ClinicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: AppBarSave(text: "Clinic Info"),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
          child: Column(
            children: [
              TextFormFiledWidget(label: "Clinic Name"),
              TextFormFiledWidget(
                  label: "Phone Number", keyboardType: TextInputType.number),
              TextFormFiledWidget(
                label: "Consultation Fee",
                keyboardType: TextInputType.number,
                suffixText: "EGY",
              ),
            ],
          ),
        ));
  }
}
