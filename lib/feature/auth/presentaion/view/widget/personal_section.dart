import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constatnt/app_string.dart';
import 'package:tabibak_for_clinic/core/extenstion/spacing.dart';
import 'package:tabibak_for_clinic/core/helper/validation.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_field.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_subtitle_text.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/password_textfiled.dart';

class PersonalSection extends StatelessWidget {
  const PersonalSection(
      {super.key,
      required this.nameController,
      required this.emailController,
      required this.phoneController,
      required this.passwordController});
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthSubtitleText(title: AppString.personalInformation),
        10.hBox,
        AuthField(lable: "Full Name", controller: nameController),
        10.hBox,
        AuthField(
            lable: AppString.email,
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            validator: (value) => Validation.validateEmail(value)),
        10.hBox,
        AuthField(
            lable: AppString.phoneNumber,
            keyboardType: TextInputType.number,
            controller: phoneController,
            validator: (value) => Validation.validateNumber(value)),
        10.hBox,
        PasswordTextfiled(
            controller: passwordController,
            validator: (value) => Validation.validatePassord(value)),
      ],
    );
  }
}
