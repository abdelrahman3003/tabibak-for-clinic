import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/functions/upload_file.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/data_source/doctor_profile_remote_data.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/dotcor_model.dart';

class DoctorProfileRemoteDataImpl implements DoctorProfileRemoteData {
  final Supabase supabase;

  DoctorProfileRemoteDataImpl({required this.supabase});
  String get currentDoctorId => supabase.client.auth.currentUser!.id;
  @override
  Future<DoctorModel?> getDoctor() async {
    final doctorId = supabase.client.auth.currentUser!.id;
    final data = await supabase.client
        .from('doctors')
        .select('*, specialties(*)')
        .eq('doctor_id', doctorId)
        .maybeSingle();
    if (data == null) return null;
    return DoctorModel.fromJson(data);
  }

  @override
  Future<void> uploadImage(String imagePath) async {
    final imageUrl = await uploadFileSupabase(
      bucket: 'profile_images',
      filePath: imagePath,
    );

    if (imageUrl == null) return;
    await supabase.client
        .from('doctors')
        .update({'image': imageUrl}).eq('doctor_id', currentDoctorId);
  }

  @override
  Future<void> updateDoctorInfo(
      {String? name, String? phone, String? address, String? bio}) async {
    final Map<String, dynamic> updateData = {};

    if (name != null) updateData['name'] = name;
    if (phone != null) updateData['phone'] = phone;
    if (address != null) updateData['address'] = address;
    if (bio != null) updateData['bio'] = bio;
    if (updateData.isEmpty) return;
    await supabase.client
        .from('doctors')
        .update(updateData)
        .eq('doctor_id', currentDoctorId);
  }
}
