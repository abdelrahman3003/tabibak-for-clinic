import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constatnt/app_string.dart';
import 'package:tabibak_for_clinic/core/extenstion/spacing.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_subtitle_text.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/decumentaion_upload_file.dart';

class DecumentSection extends StatelessWidget {
  const DecumentSection(
      {super.key,
      this.onNaionalIdSelected,
      this.onMedicalLicenseSelected,
      this.onProfilePhotoSelected,
      required this.isRegistered});
  final Function(File?)? onNaionalIdSelected;
  final Function(File?)? onMedicalLicenseSelected;
  final Function(File?)? onProfilePhotoSelected;
  final bool isRegistered;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthSubtitleText(title: AppString.documentsVerification),
        10.hBox,
        DocumentUploadField(
          title: "National ID Card",
          onFileSelected: onNaionalIdSelected,
          isRegistered: isRegistered,
        ),
        10.hBox,
        DocumentUploadField(
          title: "Medical License",
          onFileSelected: onMedicalLicenseSelected,
          isRegistered: isRegistered,
        ),
        10.hBox,
        DocumentUploadField(
          title: "Profile Photo",
          onFileSelected: onProfilePhotoSelected,
          isRegistered: isRegistered,
        ),
      ],
    );
  }
}
