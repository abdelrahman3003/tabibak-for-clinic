part of 'reset_password_bloc.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

final class ResetPasswordInitial extends ResetPasswordState {}

final class ResetPasswordLoading extends ResetPasswordState {}

final class ResetPasswordSuccess extends ResetPasswordState {}

final class ResetPasswordFailure extends ResetPasswordState {
  final String errorMessage;

  const ResetPasswordFailure({required this.errorMessage});
}
