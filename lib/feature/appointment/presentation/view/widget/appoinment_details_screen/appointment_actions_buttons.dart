import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/functions/show_confirmed_dialog.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/action_button.dart';

class AppointmentActionButtons extends StatelessWidget {
  const AppointmentActionButtons({
    super.key,
    this.onComplete,
    this.onFollowUp,
    this.onPostpone,
    this.onCancel,
    this.isCompleteLoading = false,
    this.isFollowUpLoading = false,
    this.isPostponeLoading = false,
    this.isCancelLoading = false,
    required this.appointmentDate,
    this.followUpDate,
    this.waitingList,
  });

  final VoidCallback? onComplete;
  final void Function(DateTime date)? onFollowUp;
  final void Function(int positions)? onPostpone;
  final VoidCallback? onCancel;
  final bool isCompleteLoading;
  final bool isFollowUpLoading;
  final bool isPostponeLoading;
  final bool isCancelLoading;
  final DateTime appointmentDate;
  final DateTime? followUpDate;
  final int? waitingList;

  Future<DateTime?> _pickDate(BuildContext context) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
  }

  void _showPostponeBottomSheet(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.schedule_send_rounded,
                        color: Colors.orange,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic
                                ? 'تأجيل دور المريض المتأخر'
                                : 'Postpone Late Patient Turn',
                            style: Theme.of(sheetContext)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff1E293B),
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isArabic
                                ? 'اختر عدد المواضع لتأخير ترتيب المريض في قائمة الانتظار'
                                : 'Select positions to move patient back in the queue',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _PostponeOptionTile(
                  positions: 1,
                  title: isArabic
                      ? 'تأجيل موضع واحد (+1)'
                      : 'Postpone by 1 position (+1)',
                  subtitle: isArabic
                      ? 'ينتقل المريض بعد المريض التالي مباشرة'
                      : 'Move patient after the next patient',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onPostpone?.call(1);
                  },
                ),
                const SizedBox(height: 10),
                _PostponeOptionTile(
                  positions: 2,
                  title: isArabic
                      ? 'تأجيل موضعين (+2)'
                      : 'Postpone by 2 positions (+2)',
                  subtitle: isArabic
                      ? 'ينتقل المريض بعد مريضين في الانتظار'
                      : 'Move patient after 2 patients in queue',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onPostpone?.call(2);
                  },
                ),
                const SizedBox(height: 10),
                _PostponeOptionTile(
                  positions: 3,
                  title: isArabic
                      ? 'تأجيل 3 مواضع (+3)'
                      : 'Postpone by 3 positions (+3)',
                  subtitle: isArabic
                      ? 'ينتقل المريض بعد 3 مرضى في الانتظار'
                      : 'Move patient after 3 patients in queue',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onPostpone?.call(3);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = isCompleteLoading ||
        isFollowUpLoading ||
        isPostponeLoading ||
        isCancelLoading;
    final today = DateTime.now();
    final isYourTurnToday = waitingList == 0 &&
        followUpDate == null &&
        appointmentDate.year == today.year &&
        appointmentDate.month == today.month &&
        appointmentDate.day == today.day;
    final isArabic = context.locale.languageCode == 'ar';

    return Column(
      children: [
        if (isYourTurnToday) ...[
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  label: 'Complete'.tr(),
                  color: AppColors.statusCompleted,
                  icon: Icons.task_alt_rounded,
                  isLoading: isCompleteLoading,
                  isDisabled: isBusy && !isCompleteLoading,
                  onTap: () {
                    showConfirmDialog(
                      context: context,
                      title: "Confirm Completion".tr(),
                      message:
                          "Are you sure you want to complete this appointment?"
                              .tr(),
                      onConfirm: onComplete ?? () {},
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionButton(
                  label: 'Follow-up'.tr(),
                  color: AppColors.statusUpcoming,
                  icon: Icons.event_repeat_rounded,
                  isLoading: isFollowUpLoading,
                  isDisabled: isBusy && !isFollowUpLoading,
                  onTap: () async {
                    final date = await _pickDate(context);
                    if (date != null && context.mounted) {
                      onFollowUp?.call(date);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ActionButton(
            label: isArabic
                ? 'تأجيل الدور (تأخر المريض)'
                : 'Postpone Turn (Late Patient)',
            color: Colors.orange.shade800,
            icon: Icons.schedule_send_rounded,
            isLoading: isPostponeLoading,
            isDisabled: isBusy && !isPostponeLoading,
            fullWidth: true,
            onTap: () => _showPostponeBottomSheet(context),
          ),
          const SizedBox(height: 12),
        ],
        ActionButton(
          label: 'Cancel Appointment'.tr(),
          color: AppColors.red,
          icon: Icons.close_rounded,
          isLoading: isCancelLoading,
          isDisabled: isBusy && !isCancelLoading,
          fullWidth: true,
          onTap: () {
            showConfirmDialog(
              context: context,
              title: "Confirm Cancellation".tr(),
              message: "Are you sure you want to cancel this appointment?".tr(),
              onConfirm: onCancel ?? () {},
            );
          },
        ),
      ],
    );
  }
}

class _PostponeOptionTile extends StatelessWidget {
  final int positions;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PostponeOptionTile({
    required this.positions,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
            color: Colors.orange.withOpacity(0.04),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+$positions',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xff1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
