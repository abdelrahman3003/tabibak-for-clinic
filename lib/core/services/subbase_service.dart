import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/networking/api_consatnt.dart';

import 'env_service.dart';

class SupabaseService {
  SupabaseService._();

  static Future<void> init() async {
    final apiKey = EnvService.apiKey;
    final baseUrl = EnvService.baseUrl ?? ApiConstants.supabaseApi;

    if (apiKey == null || baseUrl == null) {
      throw Exception("Supabase API_KEY or BASE_URL is missing in .env or ApiConstants");
    }

    await Supabase.initialize(url: baseUrl, anonKey: apiKey);
  }
}
