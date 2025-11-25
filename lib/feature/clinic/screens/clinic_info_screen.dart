import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/widgets/app_bar_widget.dart';

class ClinicInfoScreen extends StatelessWidget {
  const ClinicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Clinic Info"),
      body: Container(),
    );
  }
}
