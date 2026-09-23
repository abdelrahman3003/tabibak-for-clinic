import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        if (mounted)
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(AppString.reportFailed)));
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

  @override
  Widget build(BuildContext context) {
    final dateLabel = _monthly
        ? DateFormat.yMMMM().format(_selectedDate)
        : DateFormat.yMMMd().format(_selectedDate);
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
          FutureBuilder<ClinicReportEntity>(
            future: _report,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()));
              if (snapshot.hasError)
                return Center(child: Text(AppString.reportLoadFailed));
              final data = snapshot.data!;
              return Column(children: [
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
                        AppString.cancelledBookings,
                        data.cancelledBookings.toString(),
                        Icons.cancel_outlined,
                        AppColors.statusCancelled),
                    _metric(AppString.totalRevenue, _money(data.totalRevenue),
                        Icons.trending_up, AppColors.statusConfirmed),
                    _metric(AppString.totalExpenses, _money(data.totalExpenses),
                        Icons.receipt_long_outlined, AppColors.orange),
                    _metric(
                        AppString.netProfit,
                        _money(data.netProfit),
                        Icons.account_balance_wallet_outlined,
                        data.netProfit < 0
                            ? AppColors.red
                            : AppColors.statusCompleted),
                  ],
                ),
                const SizedBox(height: 18),
                Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(AppString.revenueTrend,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600))),
                const SizedBox(height: 12),
                SizedBox(
                    height: 112,
                    child: _RevenueChart(values: data.dailyRevenue)),
                Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(AppString.revenueEstimateNote,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.grey))),
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

  String _money(double value) =>
      '${value.toStringAsFixed(value % 1 == 0 ? 0 : 2)} ${AppString.currency}';
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

class _RevenueChart extends StatelessWidget {
  const _RevenueChart({required this.values});
  final List<double> values;

  @override
  Widget build(BuildContext context) {
    final buckets = values.length > 14
        ? List<double>.generate(
            7, (i) => values.skip(i * 4).take(4).fold(0, (a, b) => a + b))
        : values;
    final maxValue = buckets.fold<double>(0, (a, b) => a > b ? a : b);
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      for (final value in buckets)
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Tooltip(
            message: value.toStringAsFixed(0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor:
                      maxValue == 0 ? .04 : (value / maxValue).clamp(.04, 1),
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: .78),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4)))),
                )),
          ),
        )),
    ]);
  }
}
