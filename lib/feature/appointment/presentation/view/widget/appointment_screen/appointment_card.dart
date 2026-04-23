import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/extention/navigation.dart';
import 'package:tabibak_for_clinic/core/extention/spacing.dart';
import 'package:tabibak_for_clinic/core/functions/format_time.dart';
import 'package:tabibak_for_clinic/core/routing/routes.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/core/widgets/image_circle.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointmentEntity;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final bool showActions;
  final bool approveLoading;
  final bool rejectLoading;

  const AppointmentCard({
    super.key,
    this.onApprove,
    this.onReject,
    required this.appointmentEntity,
    this.showActions = false,
    this.approveLoading = false,
    this.rejectLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.black.withValues(alpha: 0.05),
        highlightColor: Colors.black.withValues(alpha: 0.03),
        onTap: () {
          context.pushNamed(
            Routes.appointmentDetailsScreen,
            arguments: appointmentEntity.appointmentId,
          );
        },
        child: Container(
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
                  _buildStatusBadge(context),
                ],
              ),
              if (showActions) ...[
                12.hBox,
                _buildActionButtons(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final status = appointmentEntity.statusEn ?? "";
    final color = _badgeColor(status);
    final isArabic = appointmentEntity.statusAr != null &&
        Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isArabic ? (appointmentEntity.statusAr ?? "") : status,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
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
              ?.copyWith(color: const Color(0xff64748B)),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: AppString.reject,
            color: AppColors.statusCancelled,
            icon: Icons.close_rounded,
            isLoading: rejectLoading,
            isDisabled: approveLoading,
            onTap: () => onReject?.call(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            label: AppString.approve,
            color: AppColors.statusCompleted,
            icon: Icons.check_rounded,
            isLoading: approveLoading,
            isDisabled: rejectLoading,
            onTap: () => onApprove?.call(),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
    this.isLoading = false,
    this.isDisabled = false,
  });

  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isDisabled;

  bool get _isTapEnabled => !isLoading && !isDisabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _isTapEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )
            else
              Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
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
