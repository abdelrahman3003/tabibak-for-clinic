import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  String _localized(
    BuildContext context, {
    required String english,
    required String arabic,
  }) =>
      context.locale.languageCode == 'ar' ? arabic : english;

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
        SnackBar(
          content: Text(_localized(
            context,
            english: 'Could not send your report. Please try again.',
            arabic: 'تعذر إرسال البلاغ. حاول مرة أخرى.',
          )),
        ),
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
        SnackBar(
          content: Text(_localized(
            context,
            english: 'Your report was sent.',
            arabic: 'تم إرسال بلاغك.',
          )),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_localized(
            context,
            english: 'Could not send your report. Please try again.',
            arabic: 'تعذر إرسال البلاغ. حاول مرة أخرى.',
          )),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_localized(
        context,
        english: 'Report a problem',
        arabic: 'الإبلاغ عن مشكلة',
      )),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _type,
              decoration: InputDecoration(
                labelText: _localized(
                  context,
                  english: 'Report type',
                  arabic: 'نوع البلاغ',
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: 'bug',
                  child: Text(_localized(
                    context,
                    english: 'Bug',
                    arabic: 'خلل تقني',
                  )),
                ),
                DropdownMenuItem(
                  value: 'suggestion',
                  child: Text(_localized(
                    context,
                    english: 'Suggestion',
                    arabic: 'اقتراح',
                  )),
                ),
                DropdownMenuItem(
                  value: 'other',
                  child: Text(_localized(
                    context,
                    english: 'Other',
                    arabic: 'أخرى',
                  )),
                ),
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
                labelText: _localized(
                  context,
                  english: 'Describe your issue',
                  arabic: 'اكتب وصف المشكلة',
                ),
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? _localized(
                          context,
                          english: 'Required',
                          arabic: 'مطلوب',
                        )
                      : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: Text(_localized(context, english: 'Cancel', arabic: 'إلغاء')),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submitReport,
          child: _isSubmitting
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 8),
                    Text(_localized(
                      context,
                      english: 'Sending report...',
                      arabic: 'جارٍ إرسال البلاغ...',
                    )),
                  ],
                )
              : Text(_localized(
                  context,
                  english: 'Send report',
                  arabic: 'إرسال البلاغ',
                )),
        ),
      ],
    );
  }
}
