part of 'verify_code_bloc.dart';

sealed class VerifyCodeEvent extends Equatable {
  const VerifyCodeEvent();

  @override
  List<Object> get props => [];
}

class VerifyOtpEvent extends VerifyCodeEvent {
  final String email;
  final String otp;

  const VerifyOtpEvent({required this.email, required this.otp});
  @override
  List<Object> get props => [email, otp];
}

class ResendOtp extends VerifyCodeEvent {
  final String email;

  const ResendOtp({required this.email});
  @override
  List<Object> get props => [email];
}
