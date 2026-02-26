part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class SendOtpEvent extends ForgotPasswordEvent {
  final String email;

  const SendOtpEvent({required this.email});
}
