import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({super.key, required this.title, required this.icon});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final isLogout = icon == Icons.logout;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isLogout ? AppColors.red : AppColors.grey)),
      child: Row(
        children: [
          Expanded(
            child: Text(title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isLogout ? AppColors.red : AppColors.black)),
          ),
          Icon(icon,
              size: 20, color: isLogout ? AppColors.red : AppColors.black)
        ],
      ),
    );
  }
}
