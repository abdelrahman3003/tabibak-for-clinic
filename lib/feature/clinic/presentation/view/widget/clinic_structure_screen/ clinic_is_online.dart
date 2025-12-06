import 'package:flutter/material.dart';

class ClinicIsOnline extends StatefulWidget {
  const ClinicIsOnline({super.key, this.onChanged});
  final void Function(bool?)? onChanged;
  @override
  State<ClinicIsOnline> createState() => _ClinicIsOnlineState();
}

class _ClinicIsOnlineState extends State<ClinicIsOnline> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enable this option if you want patients to book appointments online.",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
        Row(
          children: [
            Text(
              "Online Booking",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            Checkbox(
              value: isActive,
              onChanged: (value) {
                setState(() {
                  isActive = value!;
                });
                widget.onChanged?.call(value);
              },
            ),
          ],
        ),
      ],
    );
  }
}
