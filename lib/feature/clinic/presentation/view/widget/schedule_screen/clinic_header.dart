import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';

class ClinicHeader extends StatelessWidget {
  const ClinicHeader(
      {super.key, required this.clinicName, required this.clinicAddress});
  final String clinicName;
  final String clinicAddress;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(clinicName,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold, height: 30 / 36)),
        6.hBox,
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 15,
              color: AppColors.grey,
            ),
            5.hBox,
            Text(clinicAddress,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.grey)),
          ],
        ),
      ],
    );
  }
}
