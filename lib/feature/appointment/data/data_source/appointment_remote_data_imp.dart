import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/data_source/appointment_remote_data.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/models/appointment_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/models/appointment_status_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_home_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_shift_model.dart';

class AppointmentRemoteDataImp implements AppointmentRemoteData {
  final Supabase supabase;

  AppointmentRemoteDataImp({required this.supabase});
  String get currentDoctorId => supabase.client.auth.currentUser!.id;

  Future<List<AppointmentModel>> getAppointments(
    int type, {
    bool isToday = false,
  }) async {
    var query = supabase.client
        .from('appointments')
        .select(
            'name,appointments_status(status),id,appointment_date,users(image)')
        .eq('doctor_id', currentDoctorId)
        .eq('status', type);

    if (isToday) {
      final today = DateTime.now().toIso8601String().split('T').first;

      query = query.eq('appointment_date', today);
    }

    final response = await query;
    final data = response as List;

    return data.map((json) => AppointmentModel.fromJson(json)).toList();
  }

  @override
  Future<List<AppointmentStatusModel>> getAppointmentStatus() async {
    final response =
        await supabase.client.from('appointments_status').select('*');
    final data = response as List;

    return data.map((json) => AppointmentStatusModel.fromJson(json)).toList();
  }

  @override
  Future<List<AppointmentModel>> getUpcomingAppointments() async {
    return await getAppointments(3);
  }

  @override
  Future<List<AppointmentModel>> getCanceledAppointments() async {
    return await getAppointments(1);
  }

  @override
  Future<List<AppointmentModel>> getFinishedAppointments() async {
    return await getAppointments(2);
  }

  @override
  Future<AppointmentHomeEntity> getAppointmentHome() async {
    final appointmentList = await getAppointments(1, isToday: true);
    final appointmentStatusList = await getAppointmentStatus();
    return AppointmentHomeEntity(
        appointmentTodayList: appointmentList,
        appointmentStatusList: appointmentStatusList);
  }

  @override
  Future<List<AppointmentModel>> updateAppointmentStatus(
      {required int statusIndex,
      required int appointmentId,
      bool isToday = false,
      required int type}) async {
    await supabase.client.from('appointments').update({
      'status': statusIndex,
    }).eq('id', appointmentId);
    final result = await getAppointments(type, isToday: isToday);

    return result;
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
}
