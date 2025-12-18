import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/functions/upload_file.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/data_source/doctor_profile_remote_data.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/doctor_file_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/dotcor_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/education_model.dart';

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
    EducationModel? educationModel,
    List<XFile?>? files,
  }) async {
    final exists = await hasEducation(currentDoctorId);

    final futures = <Future>[];
    if (educationModel != null) {
      final data = educationModel.toJson();
      data['doctor_id'] = currentDoctorId;
      if (exists) {
        futures.add(
          supabase.client
              .from('education')
              .update(data)
              .eq('doctor_id', currentDoctorId),
        );
      } else {
        futures.add(supabase.client.from('education').insert(data));
      }
    }
    if (files != null && files.isNotEmpty) {
      futures.add(updateFiles(files));
    }
    await Future.wait(futures);
  }

  Future<void> updateFiles(List<XFile?> files) async {
    for (var file in files) {
      final imageUrl = await uploadFileSupabase(
        bucket: 'profile_images',
        filePath: file!.path,
      );

      if (imageUrl == null) continue;

      await supabase.client
          .from('doctor_file')
          .insert({'file': imageUrl, 'doctor_id': currentDoctorId});
    }
  }

  Future<bool> hasEducation(String doctorId) async {
    final data = await supabase.client
        .from('education')
        .select('id')
        .eq('doctor_id', doctorId)
        .maybeSingle();

    return data != null;
  }

  @override
  Future<List<DoctorFileModel>> getCertificates() async {
    final data = await supabase.client
        .from("doctor_file")
        .select("id,file")
        .eq("doctor_id", currentDoctorId) as List;

    return data.map((e) => DoctorFileModel.fromJson(e)).toList();
  }
}
