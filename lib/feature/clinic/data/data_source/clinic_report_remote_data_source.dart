import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_report_entity.dart';

class ClinicReportRemoteDataSource {
  ClinicReportRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<ClinicReportEntity> getReport({
    required int clinicId,
    required DateTime start,
    required DateTime end,
  }) async {
    final doctorId = _client.auth.currentUser?.id;
    if (doctorId == null) throw StateError('No signed-in doctor');

    final startDate = _date(start);
    final endDate = _date(end);
    final results = await Future.wait([
      _client
          .from('appointments')
          .select('id,status,appointment_date,follow_up_date')
          .eq('doctor_id', doctorId)
          .eq('clinic_id', clinicId)
          .gte('appointment_date', startDate)
          .lt('appointment_date', endDate),
      _client
          .from('clinic_expenses')
          .select('amount,expense_date')
          .eq('doctor_id', doctorId)
          .eq('clinic_id', clinicId)
          .gte('expense_date', startDate)
          .lt('expense_date', endDate),
      _client
          .from('appointments')
          .select(
              'consultation_fee_charged,consultation_fee_charged_at,follow_up_fee_charged,follow_up_fee_charged_at')
          .eq('doctor_id', doctorId)
          .eq('clinic_id', clinicId)
          .or('and(consultation_fee_charged_at.gte.$startDate,consultation_fee_charged_at.lt.$endDate),and(follow_up_fee_charged_at.gte.$startDate,follow_up_fee_charged_at.lt.$endDate)'),
      _client
          .from('appointments')
          .select('follow_up_date,follow_up_fee_charged_at')
          .eq('doctor_id', doctorId)
          .eq('clinic_id', clinicId)
          .eq('status', 3)
          .not('follow_up_date', 'is', null)
          .or('and(follow_up_fee_charged_at.gte.$startDate,follow_up_fee_charged_at.lt.$endDate),and(follow_up_fee_charged_at.is.null,follow_up_date.gte.$startDate,follow_up_date.lt.$endDate)'),
    ]);

    final appointments = results[0] as List;
    final expenses = results[1] as List;
    final charges = results[2] as List;
    final completedFollowUps = results[3] as List;
    final completed = appointments.where((row) {
      return row['status'] == 3 ||
          (row['status'] == 2 && row['follow_up_date'] != null);
    }).length;
    final dailyRevenue = List<double>.filled(end.difference(start).inDays, 0);

    final followUps = completedFollowUps.length;

    void addCharge(dynamic amountValue, dynamic dateValue) {
      if (amountValue == null || dateValue == null) return;
      final amount = double.tryParse(amountValue.toString()) ?? 0;
      final date = DateTime.parse(dateValue.toString());
      final index = DateTime(date.year, date.month, date.day)
          .difference(DateTime(start.year, start.month, start.day))
          .inDays;
      if (index >= 0 && index < dailyRevenue.length) {
        dailyRevenue[index] += amount;
      }
    }

    for (final row in charges) {
      addCharge(
        row['consultation_fee_charged'],
        row['consultation_fee_charged_at'],
      );
      addCharge(
        row['follow_up_fee_charged'],
        row['follow_up_fee_charged_at'],
      );
    }
    final totalRevenue = dailyRevenue.fold<double>(0, (sum, value) => sum + value);

    final totalExpenses = expenses.fold<double>(
      0,
      (sum, row) => sum + (double.tryParse(row['amount'].toString()) ?? 0),
    );
    return ClinicReportEntity(
      totalBookings: appointments.length,
      completedBookings: completed,
      followUpBookings: followUps,
      cancelledBookings: appointments.where((row) => row['status'] == 4).length,
      totalRevenue: totalRevenue.toDouble(),
      totalExpenses: totalExpenses,
      dailyRevenue: dailyRevenue,
    );
  }

  Future<void> addExpense({
    required int clinicId,
    required double amount,
    required String description,
    required DateTime date,
  }) async {
    final doctorId = _client.auth.currentUser?.id;
    if (doctorId == null) throw StateError('No signed-in doctor');
    await _client.from('clinic_expenses').insert({
      'doctor_id': doctorId,
      'clinic_id': clinicId,
      'amount': amount,
      'description': description.trim(),
      'expense_date': _date(date),
    });
  }

  String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
