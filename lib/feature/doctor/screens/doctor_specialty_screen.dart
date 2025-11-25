import 'package:flutter/material.dart';

class DoctorSpecialtyScreen extends StatelessWidget {
  const DoctorSpecialtyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Doctor Specialty",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Container(),
    );
  }
}
