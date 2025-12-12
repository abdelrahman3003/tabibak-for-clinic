import 'package:flutter/material.dart';

class ClinicWorkingDayItem extends StatefulWidget {
  const ClinicWorkingDayItem(
      {super.key, required this.text, this.onChanged, this.value = false});
  final String text;
  final void Function(bool)? onChanged;
  final bool value;
  @override
  State<ClinicWorkingDayItem> createState() => _ClinicWorkingDayItemState();
}

class _ClinicWorkingDayItemState extends State<ClinicWorkingDayItem> {
  late bool _value;
  @override
  void initState() {
    _value = widget.value;

    super.initState();
  }

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
            value: _value,
            onChanged: (value) {
              setState(() {
                _value = value;
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
