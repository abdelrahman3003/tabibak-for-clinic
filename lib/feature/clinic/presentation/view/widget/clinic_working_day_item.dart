import 'package:flutter/material.dart';

class ClinicWorkingDayItem extends StatefulWidget {
  const ClinicWorkingDayItem({super.key, required this.text, this.onChanged});
  final String text;
  final void Function(bool)? onChanged;

  @override
  State<ClinicWorkingDayItem> createState() => _ClinicWorkingDayItemState();
}

class _ClinicWorkingDayItemState extends State<ClinicWorkingDayItem> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.text,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Transform.scale(
          scale: .75,
          child: Switch(
            value: isActive,
            onChanged: (value) {
              setState(() {
                isActive = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
          ),
        )
      ],
    );
  }
}
