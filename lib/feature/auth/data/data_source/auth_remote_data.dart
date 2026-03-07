import 'package:tabibak_for_clinic/feature/doctor/data/model/dotcor_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/specialty_model.dart';

abstract class AuthRemoteData {
  Future<void> signUp({required DoctorModel doctorModel});
  Future<void> signIn(String email, String password);
  Future<DoctorModel?> signInWithGoogle();

  Future<void> sendOtp(String email);
  Future<void> resetPassword(String newPassword);
  Future<void> verifyOtp({required String email, required String otp});
  Future<String?> uploadFile(String filePath);
  Future<List<SpecialtyModel>> getSpecialties();
  Future<void> addDoctor({required DoctorModel doctorModel});
}
