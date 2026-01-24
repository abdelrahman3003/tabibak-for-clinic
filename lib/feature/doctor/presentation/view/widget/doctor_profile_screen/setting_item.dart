import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';

class SettingItem extends StatelessWidget {
  const SettingItem(
      {super.key, required this.title, required this.icon, this.onTap});
  final String title;
  final IconData icon;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final isLogout = icon == Icons.logout;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 20, color: isLogout ? AppColors.red : AppColors.black),
            12.wBox,
            Expanded(
              child: Text(title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isLogout ? AppColors.red : AppColors.black)),
            ),
            Icon(Icons.chevron_right,
                size: 20, color: isLogout ? AppColors.red : AppColors.grey),
          ],
        ),
      ),
    );
  }
}
