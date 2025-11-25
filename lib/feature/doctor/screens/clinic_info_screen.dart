import 'package:flutter/material.dart';

class ClinicInfoScreen extends StatelessWidget {
  const ClinicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Clinic Info",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Container(),
    );
  }
}
