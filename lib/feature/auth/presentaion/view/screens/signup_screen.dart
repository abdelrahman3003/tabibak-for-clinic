import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constatnt/app_string.dart';
import 'package:tabibak_for_clinic/core/extenstion/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';
import 'package:tabibak_for_clinic/core/widgets/clinic_schedule.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_field.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_subtitle_text.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/decumentaion_upload_file.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/password_textfiled.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            40.hBox,
            Center(
              child: Text(
                AppString.signUp,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            30.hBox,
            AuthSubtitleText(title: AppString.personalInformation),
            10.hBox,
            AuthField(lable: AppString.firstName),
            10.hBox,
            AuthField(lable: AppString.lastName),
            10.hBox,
            AuthField(lable: AppString.email),
            10.hBox,
            AuthField(
                lable: AppString.phoneNumber,
                keyboardType: TextInputType.number),
            10.hBox,
            PasswordTextfiled(),
            30.hBox,
            AuthSubtitleText(title: AppString.specializationInformation),
            10.hBox,
            AuthDropdown(),
            10.hBox,
            AuthField(
                lable: "Session Duration", keyboardType: TextInputType.number),
            30.hBox,
            AuthSubtitleText(title: AppString.clinicInformation),
            10.hBox,
            AuthField(lable: AppString.clinicName),
            10.hBox,
            AuthField(
                lable: "Clinic number", keyboardType: TextInputType.number),
            10.hBox,
            AuthField(lable: AppString.clinicAddress),
            10.hBox,
            AuthField(lable: AppString.consultationFee),
            30.hBox,
            AuthSubtitleText(title: "Clinic Working Days & Time"),
            10.hBox,
            ClinicScheduleWidget(),
            30.hBox,
            AuthSubtitleText(title: AppString.documentsVerification),
            10.hBox,
            DocumentUploadField(
              title: "National ID Card",
              onFileSelected: (file) {},
            ),
            10.hBox,
            DocumentUploadField(
              title: "Medical License",
              onFileSelected: (file) {},
            ),
            10.hBox,
            DocumentUploadField(
              title: "Profile Photo",
              onFileSelected: (file) {},
            ),
            20.hBox,
            AppButton(
              title: "Register",
              onPressed: () {},
            ),
            50.hBox
          ],
        ),
      ),
    ));
  }
}
