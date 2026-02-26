part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent(this.email);
  final String email;
  @override
  List<Object> get props => [email];
}
