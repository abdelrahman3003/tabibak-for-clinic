import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteData {
  Future<void> signUp(String email, String passwor);
  Future<void> signIn(String email, String passwor);
}

class AuthRemoteDataImp implements AuthRemoteData {
  final Supabase supabase;

  AuthRemoteDataImp({required this.supabase});
  @override
  Future<void> signUp(String email, String password) async {
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
}
