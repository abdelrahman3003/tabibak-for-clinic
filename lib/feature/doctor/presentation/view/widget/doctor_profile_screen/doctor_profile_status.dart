import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_profile_status_entity.dart';

class DoctorProfileStatus extends StatelessWidget {
  const DoctorProfileStatus({super.key, required this.statusEntity});

  final DoctorProfileStatusEntity statusEntity;

  _StatusStyle get _style {
    switch (statusEntity.id) {
      case 1:
        return const _StatusStyle(
          color: AppColors.primary,
          icon: Icons.check_circle_outline,
        );
      case 2:
        return const _StatusStyle(
          color: Colors.green,
          icon: Icons.cancel_outlined,
        );
      case 3:
      default:
        return const _StatusStyle(
          color: AppColors.red,
          icon: Icons.pending_actions,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: style.color.withValues(alpha: .2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            style.icon,
            size: 16,
            color: style.color,
          ),
          8.wBox,
          Text(
            statusEntity.statusEn,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: style.color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatusStyle {
  const _StatusStyle({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}
