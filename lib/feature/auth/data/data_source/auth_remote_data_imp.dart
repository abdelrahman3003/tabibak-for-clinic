import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/functions/upload_file.dart';
import 'package:tabibak_for_clinic/core/networking/api_consatnt.dart';
import 'package:tabibak_for_clinic/core/services/env_service.dart';
import 'package:tabibak_for_clinic/feature/auth/data/data_source/auth_remote_data.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/dotcor_model.dart';
import 'package:tabibak_for_clinic/feature/doctor/data/model/specialty_model.dart';

class AuthRemoteDataImp implements AuthRemoteData {
  final Supabase supabase;
  final Dio dio;

  AuthRemoteDataImp({
    required this.supabase,
    required this.dio,
  });
  @override
  Future<void> signUp({required DoctorModel doctorModel}) async {
    await supabase.client.auth
        .signUp(email: doctorModel.email, password: doctorModel.password!);
  }

  @override
  Future<void> signIn(String email, String password) async {
    final response = await supabase.client.auth
        .signInWithPassword(email: email, password: password);
    final user = response.user;
    if (user == null) throw const AuthException('Login failed');
    if (user.emailConfirmedAt == null) {
      await supabase.client.auth.signOut();
      deleteDoctor(user.id);
      throw const AuthException('email_not_confirmed');
    }
  }

  @override
  Future<void> addDoctor({required DoctorModel doctorModel}) async {
    final user = supabase.client.auth.currentUser!;
    final data = doctorModel.toJson();
    data['doctor_id'] = user.id;
    data['image'] = user.userMetadata?['avatar_url'] ?? '';
    await supabase.client.from('doctors').insert(data);
    await supabase.client.from('doctor_file').insert({
      'doctor_id': user.id,
      'file': doctorModel.medicalLicense,
    });
  }

  @override
  Future<String?> uploadFile(String filePath) async {
    final imageUrl = await uploadFileSupabase(
      bucket: 'profile_images',
      filePath: filePath,
    );
    return imageUrl;
  }

  @override
  Future<List<SpecialtyModel>> getSpecialties() async {
    final response = await dio.getUri(
      Uri.parse("${ApiConstants.apiBaseUrl}/specialties"),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = response.data as List;
      return data.map((json) => SpecialtyModel.fromJson(json)).toList();
    } else {
      throw DioException(requestOptions: response.requestOptions);
    }
  }

  @override
  Future<DoctorModel?> signInWithGoogle() async {
    final GoogleSignIn signIn = GoogleSignIn.instance;
    signIn.initialize(
        clientId: EnvService.googleClientIdIos,
        serverClientId: EnvService.googleClientIdWeb);
    final googleAcount = await signIn.authenticate();
    final idToken = googleAcount.authentication.idToken;
    if (idToken == null) {
      throw 'No Access Token found.';
    }
    final response = await supabase.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
    return await getDoctor(response.user);
  }

  @override
  Future<void> sendOtp(String email) async {
    return await supabase.client.auth.signInWithOtp(email: email);
  }

  @override
  Future<void> verifyOtp({required String email, required String otp}) async {
    await supabase.client.auth.verifyOTP(
      email: email,
      token: otp,
      type: OtpType.email,
    );
  }

  @override
  Future<UserResponse> resetPassword(String newPassword) async {
    return await supabase.client.auth
        .updateUser(UserAttributes(password: newPassword));
  }

  Future<DoctorModel?> getDoctor(User? user) async {
    final result = await supabase.client
        .from('doctors')
        .select()
        .eq('doctor_id', user!.id)
        .maybeSingle();
    if (result == null) return null;
    final doctor = DoctorModel.fromJson(result);
    return doctor;
  }

  Future<void> deleteDoctor(String doctorId) async {
    await supabase.client
        .from('doctor_file')
        .delete()
        .eq('doctor_id', doctorId);
    await supabase.client.from('doctors').delete().eq('doctor_id', doctorId);
  }
}
