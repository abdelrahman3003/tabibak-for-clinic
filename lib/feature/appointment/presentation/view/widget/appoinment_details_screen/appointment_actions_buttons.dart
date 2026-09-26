import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/functions/show_confirmed_dialog.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/appoinment_details_screen/action_button.dart';

class AppointmentActionButtons extends StatelessWidget {
  const AppointmentActionButtons({
    super.key,
    this.onComplete,
    this.onFollowUp,
    this.onCancel,
    this.isCompleteLoading = false,
    this.isFollowUpLoading = false,
    this.isCancelLoading = false,
    required this.appointmentDate,
  });

  final VoidCallback? onComplete;
  final void Function(DateTime date)? onFollowUp;
  final VoidCallback? onCancel;
  final bool isCompleteLoading;
  final bool isFollowUpLoading;
  final bool isCancelLoading;
  final DateTime appointmentDate;

  Future<DateTime?> _pickDate(BuildContext context) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = isCompleteLoading || isFollowUpLoading || isCancelLoading;
    final today = DateTime.now();
    final isAppointmentToday = appointmentDate.year == today.year &&
        appointmentDate.month == today.month &&
        appointmentDate.day == today.day;

    return Column(
      children: [
        Row(
          children: [
            if (isAppointmentToday)
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
            if (isAppointmentToday) ...[
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
                    }),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
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
