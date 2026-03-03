import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/schedule_screen/available_clinic_switch.dart';

class ClinicHeader extends StatelessWidget {
  const ClinicHeader(
      {super.key,
      required this.clinicName,
      required this.clinicAddress,
      required this.isAvailable,
      required this.clinicId});
  final String clinicName;
  final String clinicAddress;
  final bool isAvailable;
  final int clinicId;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clinicName,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold, height: 30 / 36),
              ),
              6.hBox,
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color: AppColors.grey,
                  ),
                  5.hBox,
                  Expanded(
                    child: Text(
                      clinicAddress,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AvailableClinicSwitch(clinicId: clinicId, initialValue: isAvailable)
      ],
    );
  }
}
