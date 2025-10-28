import 'dart:io';

import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/networking/api_consatnt.dart';
import 'package:tabibak_for_clinic/feature/auth/data/data_source/auth_remote_data.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/dotcor_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/signin_result_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/specialty_model.dart';

class AuthRemoteDataImp implements AuthRemoteData {
  final Supabase supabase;
  final Dio dio;
  final GoogleSignIn googleSignIn;
  AuthRemoteDataImp({
    required this.supabase,
    required this.dio,
    required this.googleSignIn,
  });
  @override
  Future<void> signUp({required String email, required String password}) async {
    final response =
        await supabase.client.auth.signUp(email: email, password: password);

    if (response.user != null) {
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
  Future<int> addDoctor({required DotcorModel dotcorModel}) async {
    final response = await dio.postUri(
        Uri.parse("${ApiConstants.apiBaseUrl}/doctors"),
        data: dotcorModel.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.data[0]['id'];
    } else {
      throw DioException(requestOptions: response.requestOptions);
    }
  }

  @override
  Future<String?> uploadFile(String filePath) async {
    final file = File(filePath);
    final uniqueName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';

    final storage = supabase.client.storage.from('profile_images');
    await storage.upload(uniqueName, file);

    final publicUrl = storage.getPublicUrl(uniqueName);
    return publicUrl;
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
    final googleUser = await googleSignIn.signIn();

    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }
    final response = await supabase.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken);
    final isRegistered = await checkDoctorRegister(response.user);
    return SigninResultModel(
      isRegistered: isRegistered,
      user: response.user,
    );
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
}
