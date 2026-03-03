import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';

class AvailableClinicSwitch extends StatefulWidget {
  const AvailableClinicSwitch({
    super.key,
    required this.isActive,
    required this.onChanged,
  });

  final bool isActive;
  final ValueChanged<bool> onChanged;

  @override
  State<AvailableClinicSwitch> createState() => _AvailableClinicSwitchState();
}

class _AvailableClinicSwitchState extends State<AvailableClinicSwitch> {
  late bool isAvailable;

  @override
  void initState() {
    super.initState();
    isAvailable = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: isAvailable,
      onChanged: (val) {
        setState(() {
          isAvailable = val;
        });

        widget.onChanged(val);
      },
      activeThumbColor: AppColors.primary,
    );
  }
}
