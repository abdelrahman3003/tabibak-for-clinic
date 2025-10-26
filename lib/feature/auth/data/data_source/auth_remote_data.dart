import 'dart:io';

import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/networking/api_consatnt.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/dotcor_model.dart';
import 'package:tabibak_for_clinic/feature/auth/data/models/specialty_model.dart';

abstract class AuthRemoteData {
  Future<void> signUp({required String email, required String password});
  Future<void> signIn(String email, String passwor);
  Future<int> addDoctor({required DotcorModel dotcorModel});
  Future<String?> uploadFile(String filePath);
  Future<List<SpecialtyModel>> getSpecialties();
}

class AuthRemoteDataImp implements AuthRemoteData {
  final Supabase supabase;
  final Dio dio;
  AuthRemoteDataImp({required this.supabase, required this.dio});
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
    final response =
        await supabase.client.auth.signUp(email: email, password: password);
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
}
