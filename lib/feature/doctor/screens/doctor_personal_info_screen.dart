import 'package:flutter/material.dart';

class DoctorPersonalInfo extends StatelessWidget {
  const DoctorPersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Doctor Personal Info",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Container(),
    );
  }
}
