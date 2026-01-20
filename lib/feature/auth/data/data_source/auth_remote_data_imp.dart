import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/functions/upload_file.dart';
import 'package:tabibak_for_clinic/core/networking/api_consatnt.dart';
import 'package:tabibak_for_clinic/core/services/env_service.dart';
import 'package:tabibak_for_clinic/feature/auth/data/data_source/auth_remote_data.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/signin_result_model.dart';
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
    var user = supabase.client.auth.currentUser;
    if (user == null) {
      final response = await supabase.client.auth
          .signUp(email: doctorModel.email, password: doctorModel.password!);
      user = response.user;
    }

    if (user != null) {
      await addUserData(user.id);
      await addDoctor(doctorModel: doctorModel, user: user);
    } else {
      throw Exception('Sign up failed');
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    final response = await supabase.client.auth
        .signInWithPassword(email: email, password: password);
    if (response.user != null) {
    } else {
      throw Exception('Sign in failed');
    }
  }

  @override
  Future<void> addDoctor(
      {required DoctorModel doctorModel, required User user}) async {
    final id = user.id;
    final data = doctorModel.toJson();
    data['doctor_id'] = id;
    data['image'] = user.userMetadata?['avatar_url'] ?? '';

    await supabase.client.from('doctors').insert(data);
    await supabase.client.from('doctor_file').insert({
      'doctor_id': id,
      'file': doctorModel.medicalLiecense,
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
  Future<SigninResultModel> signInWithGoogle() async {
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

    if (response.user != null) {
      await addUserData(response.user!.id);
    }

    final isRegistered = await checkDoctorRegister(response.user);
    return SigninResultModel(isRegistered: isRegistered, user: response.user);
  }

  @override
  Future<bool> checkDoctorRegister(User? user) async {
    final doctor = await supabase.client
        .from('doctors')
        .select()
        .eq('email', user!.email!)
        .maybeSingle();
    if (doctor == null) {
      return false;
    }
    return true;
  }

  Future<void> addUserData(String userId) async {
    await supabase.client.from('users').upsert({
      'user_id': userId,
      'is_doctor': true,
    }, onConflict: 'user_id');
  }
}
