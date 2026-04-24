import 'package:flutter/material.dart';
import 'package:tabibak_for_clinic/core/functions/show_confirmed_dialog.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
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
  });

  final VoidCallback? onComplete;
  final void Function(DateTime date)? onFollowUp;
  final VoidCallback? onCancel;
  final bool isCompleteLoading;
  final bool isFollowUpLoading;
  final bool isCancelLoading;

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

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ActionButton(
                label: 'Complete',
                color: AppColors.statusCompleted,
                icon: Icons.task_alt_rounded,
                isLoading: isCompleteLoading,
                isDisabled: isBusy && !isCompleteLoading,
                onTap: () {
                  showConfirmDialog(
                    context: context,
                    title: "Confirm Completion",
                    message:
                        "Are you sure you want to complete this appointment?",
                    onConfirm: onComplete ?? () {},
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActionButton(
                  label: 'Follow-up',
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
        ),
        const SizedBox(height: 12),
        ActionButton(
          label: 'Cancel Appointment',
          color: AppColors.red,
          icon: Icons.close_rounded,
          isLoading: isCancelLoading,
          isDisabled: isBusy && !isCancelLoading,
          fullWidth: true,
          onTap: () {
            showConfirmDialog(
              context: context,
              title: "Confirm Cancellation",
              message: "Are you sure you want to cancel this appointment?",
              onConfirm: onCancel ?? () {},
            );
          },
        ),
      ],
    );
  }
}
