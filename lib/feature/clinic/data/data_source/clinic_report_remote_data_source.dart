import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_report_entity.dart';

class ClinicReportRemoteDataSource {
  ClinicReportRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<ClinicReportEntity> getReport({
    required int clinicId,
    required int consultationFee,
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
          .select('id,status,appointment_date')
          .eq('doctor_id', doctorId)
          .gte('appointment_date', startDate)
          .lt('appointment_date', endDate),
      _client
          .from('clinic_expenses')
          .select('amount,expense_date')
          .eq('doctor_id', doctorId)
          .eq('clinic_id', clinicId)
          .gte('expense_date', startDate)
          .lt('expense_date', endDate),
    ]);

    final appointments = results[0] as List;
    final expenses = results[1] as List;
    final completed = appointments.where((row) => row['status'] == 3).length;
    final dailyRevenue = List<double>.filled(end.difference(start).inDays, 0);
    for (final row in appointments) {
      if (row['status'] != 3) continue;
      final date = DateTime.parse(row['appointment_date'].toString());
      final index = DateTime(date.year, date.month, date.day)
          .difference(DateTime(start.year, start.month, start.day))
          .inDays;
      if (index >= 0 && index < dailyRevenue.length) {
        dailyRevenue[index] += consultationFee.toDouble();
      }
    }

    final totalExpenses = expenses.fold<double>(
      0,
      (sum, row) => sum + (double.tryParse(row['amount'].toString()) ?? 0),
    );
    return ClinicReportEntity(
      totalBookings: appointments.length,
      completedBookings: completed,
      cancelledBookings: appointments.where((row) => row['status'] == 4).length,
      totalRevenue: completed * consultationFee.toDouble(),
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
