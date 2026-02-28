import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/helper/validation.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_field.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_subtitle_text.dart';

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
        AuthSubtitleText(title: AppString.universityInformation),
        10.hBox,
        AuthField(
            label: AppString.universityName,
            controller: universityNameController,
            validator: (value) => Validation.validateName(value)),
        10.hBox,
        AuthField(
            label: AppString.graduationYear,
            controller: graduationYearController,
            keyboardType: TextInputType.number,
            validator: (value) => Validation.validateNumber(value)),
      ],
    );
  }
}
