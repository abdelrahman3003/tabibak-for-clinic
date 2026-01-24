import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';

class AppointmentEmpty extends StatelessWidget {
  const AppointmentEmpty({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/appointment_empty.png",
          height: 170,
          width: 170,
        ),
        10.hBox,
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        20.hBox,
        Text(
          "You have a clear schedule for now. \nEnjoy your free time!",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: const Color(0xff64748B)),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
