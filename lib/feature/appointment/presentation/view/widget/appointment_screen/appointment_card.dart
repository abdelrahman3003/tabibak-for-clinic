import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/image_circle.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status_entity.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointmentEntity;
  final List<AppointmentStatusEntity> appointmentStatusLis;
  final ValueChanged<int>? onStatusChanged;

  /// When true, the card checks the current status:
  /// - "Upcoming" (pending) → shows Approve / Reject buttons
  /// - Any other status (e.g. "Confirmed") → shows read-only badge only
  final bool showActions;

  const AppointmentCard({
    super.key,
    this.onStatusChanged,
    required this.appointmentStatusLis,
    required this.appointmentEntity,
    this.showActions = false,
  });

  /// Returns true only when the appointment is still pending (statusEn == "Upcoming")
  bool get _isPending =>
      (appointmentEntity.statusEn ?? '').toLowerCase() == 'upcoming';

  /// Find the "Confirmed" status ID dynamically from the status list
  int? get _confirmedStatusId {
    try {
      return appointmentStatusLis
          .firstWhere(
            (s) => (s.statusEn ?? '').toLowerCase().contains('confirm'),
          )
          .id;
    } catch (_) {
      return null; // fallback – should not happen if DB has a Confirmed status
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final canTakeAction = showActions;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ImageCircle(
                imageUrl: appointmentEntity.userImage,
                radius: 26.r,
              ),
              12.wBox,
              Expanded(child: _buildNameAndDate(context)),
              _buildStatusBadge(context, isArabic),
            ],
          ),
          // Show approve/reject ONLY when pending (Upcoming status)
          if (canTakeAction) ...[
            12.hBox,
            _buildActionButtons(context),
          ],
        ],
      ),
    );
  }

  Widget _buildNameAndDate(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appointmentEntity.name ?? "",
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "${formatDayMonth(appointmentEntity.appointmentDate.toString())} · 11:00 AM",
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: const Color(0xff64748B), height: 12 / 16),
        ),
      ],
    );
  }

  /// Always read-only status badge
  Widget _buildStatusBadge(BuildContext context, bool isArabic) {
    final statusText = isArabic
        ? (appointmentEntity.statusAr ?? "")
        : (appointmentEntity.statusEn ?? "");
    final color = _badgeColor(appointmentEntity.statusEn ?? "");

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  /// Approve → "Confirmed" status | Reject → Cancelled (status 1)
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: AppString.reject,
            color: AppColors.statusCancelled,
            icon: Icons.close_rounded,
            onTap: () => onStatusChanged?.call(1), // 1 = Cancelled
          ),
        ),
        12.wBox,
        Expanded(
          child: _ActionButton(
            label: AppString.approve,
            color: AppColors.statusCompleted,
            icon: Icons.check_rounded,
            onTap: () {
              final confirmedId = _confirmedStatusId;
              if (confirmedId != null) {
                onStatusChanged?.call(confirmedId);
              }
            },
          ),
        ),
      ],
    );
  }

  Color _badgeColor(String status) {
    final s = status.toLowerCase();
    if (s == 'upcoming') return AppColors.statusUpcoming;
    if (s.contains('confirm')) return AppColors.statusConfirmed;
    if (s == 'finished' || s == 'completed') return AppColors.statusCompleted;
    if (s == 'cancelled') return AppColors.statusCancelled;
    return Colors.grey;
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            6.wBox,
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
