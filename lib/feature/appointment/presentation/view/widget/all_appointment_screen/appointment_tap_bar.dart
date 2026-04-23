import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/all_appointment_screen/item_bar.dart';

class AppointmentTapBar extends StatelessWidget {
  const AppointmentTapBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          ItemBar(
            isActive: selectedIndex == 0,
            text: AppString.upcoming,
            onTa: () => onTabChanged(0),
            activeColor: AppColors.statusUpcoming,
          ),
          ItemBar(
            isActive: selectedIndex == 1,
            text: AppString.confirmed,
            onTa: () => onTabChanged(1),
            activeColor: AppColors.statusCompleted,
          ),
          ItemBar(
            isActive: selectedIndex == 2,
            text: AppString.cancelled,
            onTa: () => onTabChanged(2),
            activeColor: AppColors.statusCancelled,
          ),
        ],
      ),
    );
  }
}
