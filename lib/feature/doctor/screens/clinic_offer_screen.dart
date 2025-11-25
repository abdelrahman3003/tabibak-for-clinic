import 'package:flutter/material.dart';

class ClinicOfferScreen extends StatelessWidget {
  const ClinicOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Clinic Offer",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Container(),
    );
  }
}
