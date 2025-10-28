part of 'signin_bloc.dart';

sealed class SigninState extends Equatable {
  const SigninState();

  @override
  List<Object> get props => [];
}

final class SigninInitial extends SigninState {}

final class SigninLoading extends SigninState {}

final class SigninSuccess extends SigninState {}

final class SigninError extends SigninState {
  final String errorMessage;

  const SigninError({required this.errorMessage});
}

final class SigninWithGoogleLoading extends SigninState {}

final class SigninWithGoogleSuccess extends SigninState {
  final SigninResultEntity signinResultEntity;

  const SigninWithGoogleSuccess({required this.signinResultEntity});
}

final class SigninWithGoogleError extends SigninState {
  final String errorMessage;

  const SigninWithGoogleError({required this.errorMessage});
}
