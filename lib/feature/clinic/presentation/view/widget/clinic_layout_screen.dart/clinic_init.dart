import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/widgets/app_button.dart';

class ClinicInit extends StatelessWidget {
  const ClinicInit({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        20.hBox,
        _buildPanner(context),
        const Spacer(),
        AppButton(
          title: "Create Clinic",
          onPressed: () {
            //    getit<SharedPrefHelper>().removeData(SharedPrefKeys.step);
            context.pushNamed(Routes.clinicStructureScreen);
          },
        ),
        10.hBox
      ],
    );
  }

  Container _buildPanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.local_hospital_rounded,
              size: 60, color: Theme.of(context).colorScheme.primary),
          16.hBox,
          Text("Setup Your Clinic",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          10.hBox,
          Text(
              "Add your clinic details, working days and schedule to get started.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium),
          10.hBox,
        ],
      ),
    );
  }
}
