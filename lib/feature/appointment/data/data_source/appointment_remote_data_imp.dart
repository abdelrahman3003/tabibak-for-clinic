import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/data_source/appointment_remote_data.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/models/appointment_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/models/appointment_status_model.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_home_entity.dart';

class AppointmentRemoteDataImp implements AppointmentRemoteData {
  final Supabase supabase;

  AppointmentRemoteDataImp({required this.supabase});
  String get currentDoctorId => supabase.client.auth.currentUser!.id;

  Future<List<AppointmentModel>> getAppointments(int type) async {
    final response = await supabase.client
        .from('appointments')
        .select(
            'appointments_status(status),id,appointment_time,appointment_date,users(name,image)')
        .eq('doctor_id', currentDoctorId)
        .eq("status", type);

    final data = response as List;
    final result = data.map((json) => AppointmentModel.fromJson(json)).toList();
    return result;
  }

  @override
  Future<List<AppointmentModel>> updateAppointmentStatus(
      int statusIndex, int appointmentId) async {
    await supabase.client.from('appointments').update({
      'status': statusIndex,
    }).eq('id', appointmentId);
    final response = await supabase.client.from('appointments').select(
          'appointments_status(status),id,appointment_time,appointment_date,users(name,image)',
        );
    final data = response as List;
    final result = data.map((json) => AppointmentModel.fromJson(json)).toList();
    return result;
  }

  @override
  Future<List<AppointmentStatusModel>> getAppointmentStatus() async {
    final response =
        await supabase.client.from('appointments_status').select('*');
    final data = response as List;

    return data.map((json) => AppointmentStatusModel.fromJson(json)).toList();
  }

  @override
  Future<AppointmentHomeEntity> getAppointmentHome() async {
    final appointmentList = await getAppointments(1);
    final appointmentStatusList = await getAppointmentStatus();
    return AppointmentHomeEntity(
        appointmentTodayList: appointmentList,
        appointmentStatusList: appointmentStatusList);
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
  Future<List<AppointmentModel>> getUpcomingAppointments() async {
    return await getAppointments(3);
  }
}
