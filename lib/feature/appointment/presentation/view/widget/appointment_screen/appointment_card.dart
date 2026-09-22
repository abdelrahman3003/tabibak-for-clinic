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

  Color get _accentColor {
    final type = appointmentEntity.appointmentTypeEn ?? "";
    if (type == 'Consultation') return AppColors.primaryDark;
    if (type == 'Follow-up') return AppColors.statusConfirmed;
    return const Color(0xff64748B);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.black.withValues(alpha: 0.03),
        highlightColor: Colors.black.withValues(alpha: 0.02),
        onTap: () {
          context.pushNamed(
            Routes.appointmentDetailsScreen,
            arguments: appointmentEntity.appointmentId,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(color: const Color(0xffE7EAEE)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderRow(context),
              12.hBox,
              Container(height: 1, color: const Color(0xffF1F3F5)),
              12.hBox,
              _buildMetaRow(context),
              if (showActions) ...[
                14.hBox,
                _buildActionButtons(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImageCircle(
          imageUrl: appointmentEntity.userImage,
          radius: 22.r,
        ),
        12.wBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointmentEntity.name ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.1,
                      color: const Color(0xff1E293B),
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                appointmentEntity.followUpDate != null
                    ? formatDayMonth(appointmentEntity.followUpDate.toString())
                    : formatDayMonth(
                        appointmentEntity.appointmentDate.toString()),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xff94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(context),
      ],
    );
  }

  Widget _buildMetaRow(BuildContext context) {
    if (appointmentEntity.queueNumber == null) return const SizedBox.shrink();
    return _buildQueueNumber(context);
  }

  Widget _buildStatusBadge(BuildContext context) {
    final appointmentType = appointmentEntity.appointmentTypeEn ?? "";
    final isArabic = appointmentEntity.appointmentTypeAr != null &&
        Localizations.localeOf(context).languageCode == 'ar';
    final color = _accentColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          6.wBox,
          Text(
            isArabic
                ? (appointmentEntity.appointmentTypeAr ?? "")
                : appointmentType,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueNumber(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.confirmation_number_outlined,
            size: 14.r, color: const Color(0xff64748B)),
        6.wBox,
        Text(
          AppString.queueNumber,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
            color: const Color(0xff94A3B8),
          ),
        ),
        4.wBox,
        Text(
          '${appointmentEntity.queueNumber}',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff1E293B),
          ),
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
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            label: AppString.approve,
            color: AppColors.statusCompleted,
            icon: Icons.check_rounded,
            isLoading: approveLoading,
            isDisabled: rejectLoading,
            onTap: () => onApprove?.call(),
            filled: true,
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
    this.filled = false,
  });

  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isDisabled;
  final bool filled;

  bool get _isTapEnabled => !isLoading && !isDisabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _isTapEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: filled ? color.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: filled ? 0.3 : 0.35),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )
            else
              Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
