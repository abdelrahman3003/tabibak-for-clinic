import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constatnt/app_string.dart';
import 'package:tabibak_for_clinic/core/extenstion/spacing.dart';
import 'package:tabibak_for_clinic/core/helper/validation.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_dropdown.dart';
import 'package:tabibak_for_clinic/feature/auth/presentaion/view/widget/auth_subtitle_text.dart';

class SpecialiseSection extends StatelessWidget {
  const SpecialiseSection({
    super.key,
    required this.bioController,
    this.onChanged,
    required this.isRegistered,
  });
  final TextEditingController bioController;
  final Function(int?)? onChanged;
  final bool isRegistered;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthSubtitleText(title: AppString.specializationInformation),
        10.hBox,
        AuthDropdown(
          onChanged: onChanged,
          isRegistered: isRegistered,
        ),
        10.hBox,
        TextFormField(
          minLines: 4,
          maxLines: 10,
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Bio",
            border: OutlineInputBorder(),
          ),
          validator: (value) => Validation.validateName(value),
        ),
      ],
    );
  }
}
