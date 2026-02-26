part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent(this.newPassword);
  final String newPassword;
  @override
  List<Object> get props => [newPassword];
}
