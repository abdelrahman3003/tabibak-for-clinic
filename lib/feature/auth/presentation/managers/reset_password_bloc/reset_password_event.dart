part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();
  @override
  List<Object> get props => [];
}

class ResetEvent extends ResetPasswordEvent {
  final String newPassword;

  const ResetEvent({required this.newPassword});
  @override
  List<Object> get props => [newPassword];
}
