import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';

class ReportDialog extends StatefulWidget {
  const ReportDialog({super.key});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _type = 'bug';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    final doctorId = getit<Supabase>().client.auth.currentUser?.id;
    if (doctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.reportFailed)),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await getit<Supabase>().client.from('support_reports').insert({
        'doctor_id': doctorId,
        'report_type': _type,
        'message': _descriptionController.text.trim(),
      });
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.reportSent)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.reportFailed)),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppString.report),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _type,
              decoration: InputDecoration(labelText: AppString.reportType),
              items: [
                DropdownMenuItem(value: 'bug', child: Text(AppString.bugReport)),
                DropdownMenuItem(
                    value: 'suggestion', child: Text(AppString.suggestion)),
                DropdownMenuItem(
                    value: 'other', child: Text(AppString.otherReport)),
              ],
              onChanged: _isSubmitting
                  ? null
                  : (value) {
                      if (value != null) setState(() => _type = value);
                    },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 5,
              maxLength: 1000,
              enabled: !_isSubmitting,
              decoration: InputDecoration(
                labelText: AppString.describeIssue,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? AppString.required : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: Text(AppString.cancel),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submitReport,
          child: _isSubmitting
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppString.sendReport),
        ),
      ],
    );
  }
}
