import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/doctor_personal_info_screen/app_bar_save.dart';

class ClinicAddressScreen extends StatelessWidget {
  const ClinicAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: AppBarSave(text: "Clinic Address"),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TextFormFiledWidget(label: "Clinic Address"),
              TextFormFiledWidget(label: "Clinic Directions")
            ],
          ),
        ));
  }
}
