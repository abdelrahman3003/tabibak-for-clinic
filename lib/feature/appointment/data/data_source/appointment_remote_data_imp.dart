import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/data_source/appointment_remote_data.dart';
import 'package:tabibak_for_clinic/feature/appointment/data/models/appointment_model.dart';

class AppointmentRemoteDataImp implements AppointmentRemoteData {
  final Supabase supabase;

  AppointmentRemoteDataImp({required this.supabase});
  String get currentDoctorId => supabase.client.auth.currentUser!.id;

  @override
  Future<List<AppointmentModel>> getAppointments() async {
    final today = DateTime.now().toString().split(' ')[0];

    final response = await supabase.client
        .from('appointments')
        .select(
            'appointments_status(status),appointment_time,appointment_date,users(name,image)')
        .eq('doctor_id', currentDoctorId);

    final data = response as List;
    final result = data.map((json) => AppointmentModel.fromJson(json)).toList();
    return result;
  }
}
