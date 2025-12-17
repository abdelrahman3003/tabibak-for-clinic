import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';

class ProfileTitle extends StatelessWidget {
  const ProfileTitle({super.key, required this.title, required this.icon});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        10.wBox,
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
