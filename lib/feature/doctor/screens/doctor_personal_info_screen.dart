import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_save.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';

class DoctorPersonalInfo extends StatelessWidget {
  const DoctorPersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarSave(
          text: "Doctor Personal Info",
          onTap: () {},
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
          child: Column(
            children: [
              TextFormFiledWidget(label: "Doctor Name"),
              TextFormFiledWidget(label: "Phone"),
              TextFormFiledWidget(label: "Address"),
              TextFormFiledWidget(label: "Bio"),
            ],
          ),
        ));
  }
}
