import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/extenstion/spacing.dart';
import 'package:tabibak_for_clinic/core/widgets/shift_section.dart';

class ClinicScheduleWidget extends StatefulWidget {
  const ClinicScheduleWidget({super.key});

  @override
  State<ClinicScheduleWidget> createState() => _ClinicScheduleWidgetState();
}

class _ClinicScheduleWidgetState extends State<ClinicScheduleWidget> {
  final List<String> _days = const [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  final Map<String, bool> _selectedDays = {};
  final Map<String, TimeOfDay?> _morningStart = {};
  final Map<String, TimeOfDay?> _morningEnd = {};
  final Map<String, TimeOfDay?> _eveningStart = {};
  final Map<String, TimeOfDay?> _eveningEnd = {};

  @override
  void initState() {
    super.initState();
    for (final day in _days) {
      _selectedDays[day] = false;
    }
  }

  Future<TimeOfDay?> _pickTime(TimeOfDay? initial) async {
    return showTimePicker(
      context: context,
      initialTime: initial ?? const TimeOfDay(hour: 9, minute: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._days.map((day) => _buildDaySection(day)),
      ],
    );
  }

  Widget _buildDaySection(String day) {
    final isSelected = _selectedDays[day] ?? false;

    return Column(
      children: [
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(day),
          value: isSelected,
          onChanged: (value) => setState(() => _selectedDays[day] = value!),
        ),
        if (isSelected)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShiftSection(
                  title: "Morning Shift",
                  start: _morningStart[day],
                  end: _morningEnd[day],
                  onStartTap: () async {
                    final time = await _pickTime(_morningStart[day]);
                    if (time != null) setState(() => _morningStart[day] = time);
                  },
                  onEndTap: () async {
                    final time = await _pickTime(_morningEnd[day]);
                    if (time != null) setState(() => _morningEnd[day] = time);
                  },
                ),
                8.hBox,
                ShiftSection(
                  title: "Evening Shift",
                  start: _eveningStart[day],
                  end: _eveningEnd[day],
                  onStartTap: () async {
                    final time = await _pickTime(_eveningStart[day]);
                    if (time != null) setState(() => _eveningStart[day] = time);
                  },
                  onEndTap: () async {
                    final time = await _pickTime(_eveningEnd[day]);
                    if (time != null) setState(() => _eveningEnd[day] = time);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Map<String, dynamic> _collectSchedule() {
    final Map<String, dynamic> schedule = {};
    for (final day in _days) {
      if (_selectedDays[day] == true) {
        schedule[day] = {
          'morning': {
            'start': _morningStart[day]?.format(context),
            'end': _morningEnd[day]?.format(context),
          },
          'evening': {
            'start': _eveningStart[day]?.format(context),
            'end': _eveningEnd[day]?.format(context),
          },
        };
      }
    }
    return schedule;
  }
}
