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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: AppColors.second,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(clinicName, style: Theme.of(context).textTheme.titleLarge),
          6.hBox,
          Text(clinicAddress, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
