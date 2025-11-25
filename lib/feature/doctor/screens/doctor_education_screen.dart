import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/text_form_filed_widget.dart';
import 'package:tabibak_for_clinic/feature/doctor/widget/doctor_personal_info_screen/app_bar_save.dart';

class DoctorEducationScreen extends StatelessWidget {
  const DoctorEducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarSave(text: "Doctor Education"),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.hBox,
              const TextFormFiledWidget(label: "Country"),
              20.hBox,
              const TextFormFiledWidget(label: "University"),
              20.hBox,
              const TextFormFiledWidget(label: "Degree"),
              20.hBox,
              const TextFormFiledWidget(label: "Year"),
              20.hBox,
              Text(
                "Certificate Photo",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              10.hBox,
              _buildCertificatePhoto(context)
            ],
          ),
        ));
  }

  _buildCertificatePhoto(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(border: Border.all(color: AppColors.primary)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
            5.wBox,
            Text(
              "Certificate Photo",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
