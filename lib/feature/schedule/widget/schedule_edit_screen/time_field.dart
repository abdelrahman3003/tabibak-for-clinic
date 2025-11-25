import 'package:flutter/material.dart';

class TimeField extends StatefulWidget {
  final void Function(TimeOfDay time)? onTimeSelected;
  final bool enable;
  final String? value;
  const TimeField(
      {super.key,
      this.onTimeSelected,
      required this.enable,
      required this.value});

  @override
  State<TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  TimeOfDay? selectedTime;

  Future<void> pickTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });

      if (widget.onTimeSelected != null) {
        widget.onTimeSelected!(time);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enable ? pickTime : null,
      child: AbsorbPointer(
        child: TextFormField(
          enabled: widget.enable,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: Colors.transparent,
            border: const UnderlineInputBorder(),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
          ),
          controller: TextEditingController(
            text: selectedTime == null
                ? widget.value ?? "Select Time"
                : selectedTime!.format(context),
          ),
          readOnly: true,
        ),
      ),
    );
  }
}
