import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/signin_result_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/dotcor_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/specialty_model.dart';

abstract class AuthRemoteData {
  Future<void> signUp({required DoctorModel doctorModel});
  Future<void> signIn(String email, String password);
  Future<SigninResultModel> signInWithGoogle();
  Future<void> addDoctor(
      {required DoctorModel doctorModel, required String id});
  Future<String?> uploadFile(String filePath);
  Future<List<SpecialtyModel>> getSpecialties();
  Future<bool> checkDoctorRegister(User? user);
}
