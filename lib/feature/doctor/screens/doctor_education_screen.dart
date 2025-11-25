import 'package:flutter/material.dart';

class DoctorEducationScreen extends StatelessWidget {
  const DoctorEducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Doctor Education",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Container(),
    );
  }
}
