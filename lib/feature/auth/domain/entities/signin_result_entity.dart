import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SigninResultEntity extends Equatable {
  final bool isRegistered;
  final User? user;

  const SigninResultEntity({required this.isRegistered, this.user});
  @override
  List<Object?> get props => [isRegistered, user];
}
