import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';

class PatientCard extends StatelessWidget {
  const PatientCard({
    super.key,
    required this.entity,
    required this.statusLabel,
  });

  final AppointmentEntity entity;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(entity.statusId);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 70.r,
            height: 70.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  statusColor.withValues(alpha: 0.2),
                  statusColor.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                  color: statusColor.withValues(alpha: 0.3), width: 2),
            ),
            child: entity.userImage != null
                ? ClipOval(
                    child: Image.network(
                      entity.userImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _defaultAvatar(statusColor),
                    ),
                  )
                : _defaultAvatar(statusColor),
          ),

          16.wBox,

          // Name + status badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entity.name ?? 'Unknown Patient'.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                6.hBox,
                // Status badge
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                    border:
                        Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar(Color color) => Icon(
        Icons.person_rounded,
        size: 36.r,
        color: color,
      );

  Color _statusColor(int? id) {
    switch (id) {
      case 1:
        return const Color(0xFFF59E0B);
      case 2:
        return const Color(0xFF10B981);
      case 3:
        return const Color(0xFF10B981);
      case 4:
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }
}
