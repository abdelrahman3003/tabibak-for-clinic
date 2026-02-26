part of 'verify_code_bloc.dart';

sealed class VerifyCodeEvent extends Equatable {
  const VerifyCodeEvent(this.email, this.otp);
  final String email;
  final String otp;
  @override
  List<Object> get props => [email, otp];
}
