import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/functions/upload_file.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/data_source/doctor_profile_remote_data.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/dotcor_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/education_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/specialty_model.dart';

class DoctorProfileRemoteDataImpl implements DoctorProfileRemoteData {
  final Supabase supabase;

  DoctorProfileRemoteDataImpl({required this.supabase});
  String get currentDoctorId => supabase.client.auth.currentUser!.id;
  @override
  Future<DoctorModel?> getDoctor() async {
    final data = await supabase.client
        .from('doctors')
        .select('*, specialties(*),education(*)')
        .eq('doctor_id', currentDoctorId)
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

  @override
  Future<void> updateEducation({
    required EducationModel educationModel,
    XFile? file,
  }) async {
    final data = educationModel.toJson()
      ..removeWhere((key, value) => value == null);
    data['doctor_id'] = currentDoctorId;
    if (file != null) {
      final imageUrl = await uploadFileSupabase(
        bucket: 'profile_images',
        filePath: file.path,
      );
      data['certificate'] = imageUrl;
    }
    await supabase.client
        .from('education')
        .update(data)
        .eq('doctor_id', currentDoctorId);
  }

  @override
  Future<void> updateSpecialty({required int specialtyId}) async {
    await supabase.client
        .from('doctors')
        .update({'specialty': specialtyId}).eq('doctor_id', currentDoctorId);
  }

  @override
  Future<List<SpecialtyModel>> getSpecialties() async {
    final response = await supabase.client.from("specialties").select();
    final data = response as List<dynamic>;
    return data.map((json) => SpecialtyModel.fromJson(json)).toList();
  }

  @override
  Future<void> logOut() async {
    await supabase.client.auth.signOut();
  }
}
