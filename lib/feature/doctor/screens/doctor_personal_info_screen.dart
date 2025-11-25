import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/doctor_personal_info_screen/app_bar_save.dart';

class DoctorPersonalInfo extends StatelessWidget {
  const DoctorPersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarSave(
          text: "Doctor Personal Info",
          onTap: () {},
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              10.hBox,
              const TextFormFiledWidget(label: "Doctor Name"),
              15.hBox,
              const TextFormFiledWidget(label: "Phone"),
              15.hBox,
              const TextFormFiledWidget(label: "Address"),
              15.hBox,
              const TextFormFiledWidget(label: "Bio"),
            ],
          ),
        ));
  }
}
