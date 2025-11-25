import 'package:flutter/material.dart';

class ClinicAddressScreen extends StatelessWidget {
  const ClinicAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Clinic Address",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Container(),
    );
  }
}
