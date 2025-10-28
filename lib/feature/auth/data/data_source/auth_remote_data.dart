import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/dotcor_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/signin_result_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/specialty_model.dart';

abstract class AuthRemoteData {
  Future<void> signUp({required String email, required String password});
  Future<void> signIn(String email, String passwor);
  Future<SigninResultModel> signInWithGoogle();
  Future<int> addDoctor({required DotcorModel dotcorModel});
  Future<String?> uploadFile(String filePath);
  Future<List<SpecialtyModel>> getSpecialties();
  Future<bool> checkDoctorRegister(User? user);
}
