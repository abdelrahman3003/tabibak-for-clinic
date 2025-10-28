import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extenstion/spacing.dart';
import 'package:tabibak_for_clinic/core/helper/validation.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_field.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_subtitle_text.dart';

class UniversitySection extends StatelessWidget {
  const UniversitySection(
      {super.key,
      required this.universityNameController,
      required this.graduationYearController});
  final TextEditingController universityNameController;
  final TextEditingController graduationYearController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthSubtitleText(title: "University Information"),
        10.hBox,
        AuthField(
            lable: "University Name",
            controller: universityNameController,
            validator: (value) => Validation.validateName(value)),
        10.hBox,
        AuthField(
            lable: "Graduation Year",
            controller: graduationYearController,
            keyboardType: TextInputType.number,
            validator: (value) => Validation.validateNumber(value)),
      ],
    );
  }
}
