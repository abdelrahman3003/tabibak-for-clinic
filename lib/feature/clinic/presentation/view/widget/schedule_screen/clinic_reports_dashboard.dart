import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/constant/app_string.dart';
import 'package:tabibak_for_clinic/core/theme/app_colors.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/data_source/clinic_report_remote_data_source.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_report_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_reports_refresh_notifier.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';

class ClinicReportsDashboard extends StatefulWidget {
  const ClinicReportsDashboard({super.key, required this.clinic});

  final ClinicInfoEntity clinic;

  @override
  State<ClinicReportsDashboard> createState() => _ClinicReportsDashboardState();
}

class _ClinicReportsDashboardState extends State<ClinicReportsDashboard> {
  late DateTime _selectedDate;
  bool _monthly = false;
  late Future<ClinicReportEntity> _report;
  final ClinicReportsRefreshNotifier _refreshNotifier =
      getit<ClinicReportsRefreshNotifier>();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _load();
    _refreshNotifier.addListener(_refresh);
  }

  @override
  void dispose() {
    _refreshNotifier.removeListener(_refresh);
    super.dispose();
  }

  (DateTime, DateTime) get _range {
    if (_monthly) {
      final start = DateTime(_selectedDate.year, _selectedDate.month);
      return (start, DateTime(start.year, start.month + 1));
    }
    final start =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    return (start, start.add(const Duration(days: 1)));
  }

  void _load() {
    final (start, end) = _range;
    _report = ClinicReportRemoteDataSource(Supabase.instance.client).getReport(
      clinicId: widget.clinic.id!,
      consultationFee: widget.clinic.consultationFee ?? 0,
      followUpFee: widget.clinic.followUpFee ?? 0,
      start: start,
      end: end,
    );
  }

  void _refresh() => setState(_load);

  Future<void> _addExpense() async {
    final expense = await showDialog<_ExpenseDraft>(
      context: context,
      builder: (_) => const _AddExpenseDialog(),
    );
    if (expense != null && mounted) {
      try {
        await ClinicReportRemoteDataSource(Supabase.instance.client).addExpense(
          clinicId: widget.clinic.id!,
          amount: expense.amount,
          description: expense.description,
          date: _selectedDate,
        );
        _refresh();
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppString.expenseSaveFailed)));
        }
      }
    }
  }

  void _changeDate(int delta) {
    setState(() {
      _selectedDate = _monthly
          ? DateTime(_selectedDate.year, _selectedDate.month + delta)
          : _selectedDate.add(Duration(days: delta));
      _load();
    });
  }

  Future<void> _shareReport(
    ClinicReportEntity data,
    BuildContext buttonContext,
  ) async {
    try {
      final locale = context.locale.toString();
      final period = _monthly
          ? DateFormat.yMMMM(locale).format(_selectedDate)
          : DateFormat.yMMMd(locale).format(_selectedDate);
      final lines = <String>[
        widget.clinic.clinicName ?? AppString.clinicReports,
        '${_monthly ? AppString.monthlyReport : AppString.dailyReport}: $period',
        '${AppString.totalBookings}: ${data.totalBookings}',
        '${AppString.completedBookings}: ${data.completedBookings}',
        '${AppString.followUpBookings}: ${data.followUpBookings}',
        '${AppString.cancelledBookings}: ${data.cancelledBookings}',
        '${AppString.totalRevenue}: ${_money(data.totalRevenue, locale)}',
        '${AppString.totalExpenses}: ${_money(data.totalExpenses, locale)}',
        '${AppString.netProfit}: ${_money(data.netProfit, locale)}',
      ];
      if (_monthly) {
        lines.add('');
        lines.add('${AppString.dailyRevenueBreakdown}:');
        for (var index = 0; index < data.dailyRevenue.length; index++) {
          final day =
              DateTime(_selectedDate.year, _selectedDate.month, index + 1);
          lines.add(
            '${DateFormat.yMMMd(locale).format(day)}: ${_money(data.dailyRevenue[index], locale)}',
          );
        }
      }
      lines.add('');
      lines.add(AppString.revenueEstimateNote);

      final text = lines.join('\n');

      final buttonBox = buttonContext.findRenderObject() as RenderBox?;
      final sharePositionOrigin = buttonBox == null
          ? null
          : buttonBox.localToGlobal(Offset.zero) & buttonBox.size;

      await Share.share(
        text,
        subject:
            '${_monthly ? AppString.monthlyReport : AppString.dailyReport} - $period',
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (error, stackTrace) {
      developer.log(
        'Failed to share clinic report',
        error: error,
        stackTrace: stackTrace,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppString.reportShareFailed} ($error)')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.toString();
    final dateLabel = _monthly
        ? DateFormat.yMMMM(locale).format(_selectedDate)
        : DateFormat.yMMMd(locale).format(_selectedDate);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Text(AppString.clinicReports,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold))),
            Builder(
              builder: (buttonContext) => IconButton(
                  onPressed: () {
                    final snapshot = _report;
                    snapshot.then((data) => _shareReport(data, buttonContext));
                  },
                  tooltip: AppString.shareReport,
                  icon: const Icon(Icons.share_outlined)),
            ),
            IconButton(
                onPressed: _addExpense,
                tooltip: AppString.addExpense,
                icon: const Icon(Icons.add_card_outlined)),
            IconButton(
                onPressed: _refresh,
                tooltip: AppString.refresh,
                icon: const Icon(Icons.refresh)),
          ]),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text(AppString.daily)),
              ButtonSegment(value: true, label: Text(AppString.monthly)),
            ],
            selected: {_monthly},
            onSelectionChanged: (selection) => setState(() {
              _monthly = selection.first;
              _load();
            }),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(
                onPressed: () => _changeDate(-1),
                icon: const Icon(Icons.chevron_left)),
            Text(dateLabel, style: Theme.of(context).textTheme.titleMedium),
            IconButton(
                onPressed: () => _changeDate(1),
                icon: const Icon(Icons.chevron_right)),
          ]),
          Center(
            child: Text(
              _monthly ? AppString.monthlyReport : AppString.dailyReport,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          FutureBuilder<ClinicReportEntity>(
            future: _report,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return Center(child: Text(AppString.reportLoadFailed));
              }
              final data = snapshot.data!;
              return Column(children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(AppString.revenueEstimateNote,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.grey,
                            )),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.9,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    _metric(
                        AppString.totalBookings,
                        data.totalBookings.toString(),
                        Icons.event_note,
                        AppColors.primary),
                    _metric(
                        AppString.completedBookings,
                        data.completedBookings.toString(),
                        Icons.check_circle_outline,
                        AppColors.statusCompleted),
                    _metric(
                        AppString.followUpBookings,
                        data.followUpBookings.toString(),
                        Icons.event_repeat_outlined,
                        AppColors.primary),
                    _metric(
                        AppString.cancelledBookings,
                        data.cancelledBookings.toString(),
                        Icons.cancel_outlined,
                        AppColors.statusCancelled),
                    _metric(
                        AppString.totalRevenue,
                        _money(data.totalRevenue, locale),
                        Icons.trending_up,
                        AppColors.statusConfirmed),
                    _metric(
                        AppString.totalExpenses,
                        _money(data.totalExpenses, locale),
                        Icons.receipt_long_outlined,
                        AppColors.orange),
                    _metric(
                        AppString.netProfit,
                        _money(data.netProfit, locale),
                        Icons.account_balance_wallet_outlined,
                        data.netProfit < 0
                            ? AppColors.red
                            : AppColors.statusCompleted),
                  ],
                ),
                if (_monthly) ...[
                  const SizedBox(height: 20),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(AppString.dailyRevenueBreakdown,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                  ),
                  const SizedBox(height: 8),
                  ...List<Widget>.generate(data.dailyRevenue.length, (index) {
                    final day = DateTime(
                        _selectedDate.year, _selectedDate.month, index + 1);
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 16,
                        child: Text('${index + 1}',
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                      title: Text(DateFormat.yMMMd(locale).format(day)),
                      trailing: Text(
                        _money(data.dailyRevenue[index], locale),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    );
                  }),
                ],
              ]);
            },
          ),
        ]),
      ),
    );
  }

  Widget _metric(String title, String value, IconData icon, Color color) =>
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.grey)),
                Text(value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ])),
        ]),
      );

  String _money(double value, String locale) =>
      '${NumberFormat.decimalPattern(locale).format(value % 1 == 0 ? value.toInt() : value)} ${AppString.currency}';
}

class _ExpenseDraft {
  const _ExpenseDraft({required this.amount, required this.description});

  final double amount;
  final String description;
}

class _AddExpenseDialog extends StatefulWidget {
  const _AddExpenseDialog();

  @override
  State<_AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<_AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      _ExpenseDraft(
        amount: double.parse(_amountController.text),
        description: _descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppString.addExpense),
      content: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: AppString.amount),
            validator: (value) {
              final amount = double.tryParse(value ?? '');
              return amount == null || amount <= 0 ? AppString.required : null;
            },
          ),
          TextFormField(
            controller: _descriptionController,
            maxLength: 200,
            decoration: InputDecoration(labelText: AppString.description),
            validator: (value) => value == null || value.trim().isEmpty
                ? AppString.required
                : null,
          ),
        ]),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppString.cancel),
        ),
        FilledButton(onPressed: _save, child: Text(AppString.save)),
      ],
    );
  }
}
