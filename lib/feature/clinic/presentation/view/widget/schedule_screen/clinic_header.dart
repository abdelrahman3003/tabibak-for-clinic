import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/dialogs.dart';

class ClinicHeader extends StatefulWidget {
  const ClinicHeader(
      {super.key,
      required this.clinicName,
      required this.clinicAddress,
      required this.isAvailable});
  final String clinicName;
  final String clinicAddress;
  final bool isAvailable;
  @override
  State<ClinicHeader> createState() => _ClinicHeaderState();
}

class _ClinicHeaderState extends State<ClinicHeader> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.isAvailable; // ياخد القيمة من بره أول مرة
  }

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
                widget.clinicName,
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
                      widget.clinicAddress,
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
        Switch.adaptive(
          value: isActive,
          onChanged: (val) {
            showDialog(
              context: context,
              builder: (context) => Dialogs.alertDialog(
                context: context,
                title: AppString.changeAvailability,
                subtitle: AppString.changeAvailabilitySubtitle,
                confirmString: AppString.confirm,
                color: AppColors.primary,
                isLoading: false,
                onPressed: () {
                  setState(() {
                    isActive = val;
                  });
                  Navigator.pop(context);
                },
              ),
            );
          },
          activeThumbColor: AppColors.primary,
        )
      ],
    );
  }
}
