import 'package:flutter/material.dart';
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

  void _showCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Complete Appointment'),
        content: const Text('Would you like to schedule a follow-up?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onComplete?.call();
            },
            child: const Text('No Follow-up'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final date = await _pickDate(context);
              if (date != null && context.mounted) {
                onFollowUp?.call(date);
              }
            },
            child: const Text('Pick Date'),
          ),
        ],
      ),
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
                onTap: () => _showCompleteDialog(context),
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
                },
              ),
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
          onTap: onCancel,
        ),
      ],
    );
  }
}
