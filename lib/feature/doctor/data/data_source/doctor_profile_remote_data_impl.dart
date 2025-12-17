import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/data_source/doctor_profile_remote_data.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/dotcor_model.dart';

class DoctorProfileRemoteDataImpl implements DoctorProfileRemoteData {
  final Supabase supabase;

  DoctorProfileRemoteDataImpl({required this.supabase});

  @override
  Future<DoctorModel?> getDoctor() async {
    final doctorId = supabase.client.auth.currentUser!.id;
    final data = await supabase.client
        .from('Doctor')
        .select('*, specialties(*)')
        .eq('doctor_id', doctorId)
        .maybeSingle();
    if (data == null) return null;
    return DoctorModel.fromJson(data);
  }
}
