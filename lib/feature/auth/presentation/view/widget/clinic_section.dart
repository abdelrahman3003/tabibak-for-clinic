import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/helper/validation.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_field.dart';
import 'package:tabibak_for_clinic/feature/auth/presentation/view/widget/auth_subtitle_text.dart';

class ClinicSection extends StatelessWidget {
  const ClinicSection(
      {super.key,
      required this.clinicNameController,
      required this.clinicPhoneController,
      required this.addressController,
      required this.consultationFeeController});
  final TextEditingController clinicNameController;
  final TextEditingController clinicPhoneController;
  final TextEditingController addressController;
  final TextEditingController consultationFeeController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthSubtitleText(title: AppString.clinicInformation),
        10.hBox,
        AuthField(
          lable: AppString.clinicName,
          controller: clinicNameController,
          validator: (value) => Validation.validateName(value),
        ),
        10.hBox,
        AuthField(
          lable: "Clinic number",
          keyboardType: TextInputType.number,
          controller: clinicPhoneController,
          validator: (value) => Validation.validateName(value),
        ),
        10.hBox,
        AuthField(
          lable: AppString.clinicAddress,
          controller: addressController,
          validator: (value) => Validation.validateName(value),
        ),
        10.hBox,
        AuthField(
            lable: AppString.consultationFee,
            controller: consultationFeeController,
            keyboardType: TextInputType.number,
            validator: (value) => Validation.validateNumber(value)),
        30.hBox,
      ],
    );
  }
}
