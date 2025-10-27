part of 'signin_bloc.dart';

sealed class SigninEvent extends Equatable {
  const SigninEvent();

  @override
  List<Object> get props => [];
}

class SignInRequestedEvent extends SigninEvent {
  final String email;
  final String password;

  const SignInRequestedEvent({required this.email, required this.password});
}

class SignInWithGoogleEvent extends SigninEvent {
  const SignInWithGoogleEvent();
}
