import 'package:flutter/material.dart';

class ClinicIsOnline extends StatefulWidget {
  const ClinicIsOnline({super.key, this.onChanged, this.value = false});
  final void Function(bool?)? onChanged;
  final bool value;
  @override
  State<ClinicIsOnline> createState() => _ClinicIsOnlineState();
}

class _ClinicIsOnlineState extends State<ClinicIsOnline> {
  late bool _value;
  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

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
              value: _value,
              onChanged: (value) {
                setState(() {
                  _value = value!;
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
