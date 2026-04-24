import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/data_source/appointment_remote_data.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/models/appointment_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_shift_model.dart';

class AppointmentRemoteDataImp implements AppointmentRemoteData {
  final Supabase supabase;

  AppointmentRemoteDataImp({required this.supabase});
  String get currentDoctorId => supabase.client.auth.currentUser!.id;

  @override
  Future<List<AppointmentModel>> getAppointments(
      {int? type, bool? isToday}) async {
    var query = supabase.client
        .from('appointments')
        .select(
            'name,appointment_types(*),appointments_status(status_en,status_ar),id,appointment_date,users(image)')
        .eq('doctor_id', currentDoctorId)
        .eq('status', type ?? 1);

    final today = DateTime.now().toIso8601String().split('T').first;

    if (type == 5) {
      if (isToday == true) {
        query = query.eq('appointment_date', today);
      } else {
        query = query.gte('appointment_date', today);
      }
    }

    final response = await query.order('appointment_date', ascending: true);
    final data = response as List;

    return data.map((json) => AppointmentModel.fromJson(json)).toList();
  }

  @override
  Future<void> updateAppointmentStatus({
    required int statusIndex,
    required int appointmentId,
  }) async {
    await supabase.client.functions.invoke(
      'update_appointment',
      body: {
        'appointment_id': appointmentId,
        'status': statusIndex,
      },
    );
  }

  @override
  Future<void> addAppointment(AppointmentModel appointment) async {
    await supabase.client.from('appointments').insert(appointment.toJson());
  }

  @override
  Future<ClinicShiftModel?> getAppointmentShift(String dayEn) async {
    final response = await supabase.client.rpc(
      'get_shift_by_day',
      params: {'p_day_en': dayEn},
    );
    if (response == null) return null;

    return ClinicShiftModel.fromJson(response);
  }

  @override
  Future<AppointmentModel> getAppointmentDetails(int appointmentId) async {
    final response = await supabase.client.from('appointments').select('''
        *,
        appointments_status(status_en, status_ar,id),
        users(image, name,user_id)
      ''').eq('id', appointmentId).single();

    return AppointmentModel.fromJson(response);
  }
}
