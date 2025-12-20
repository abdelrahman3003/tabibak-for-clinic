import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/functions/pick_image.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/doctor/presentation/view/widget/doctor_profile_screen/education_image.dart';

class EducationCertificates extends StatefulWidget {
  final Function(XFile?) onSelected;
  final String? imageUrl;
  const EducationCertificates({
    super.key,
    required this.onSelected,
    required this.imageUrl,
  });

  @override
  State<EducationCertificates> createState() => _EducationCertificatesState();
}

class _EducationCertificatesState extends State<EducationCertificates> {
  XFile? selectedFile;
  Future<void> _pickCertificate() async {
    selectedFile = await pickImage();
    widget.onSelected(selectedFile);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedFile != null || widget.imageUrl != null)
          InkWell(
            onTap: () async {
              await _pickCertificate();
            },
            child: EducationImage(
              imageUrl: widget.imageUrl,
              file: selectedFile,
            ),
          ),
        10.hBox,
        if (selectedFile == null && widget.imageUrl == null)
          InkWell(
            onTap: () async {
              await _pickCertificate();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration:
                  BoxDecoration(border: Border.all(color: AppColors.primary)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                  5.wBox,
                  Text(
                    "Add Certificate",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
