import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_values.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_layout_screen/clinic_init.dart';

class CreateClinicScreen extends StatelessWidget {
  const CreateClinicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(AppPadding.horizontal),
        child: ClinicInit(),
      ),
    );
  }
}
