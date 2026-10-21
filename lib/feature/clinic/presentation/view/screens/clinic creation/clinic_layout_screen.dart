import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_padding.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/view/widget/clinic_layout_screen/clinic_init.dart';

class CreateClinicScreen extends StatelessWidget {
  const CreateClinicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppString.createClinic),
      body: const Padding(
        padding: EdgeInsets.all(AppPadding.horizontal),
        child: ClinicInit(),
      ),
    );
  }
}
