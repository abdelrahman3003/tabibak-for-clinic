part of 'splash_bloc.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

final class SplashInitial extends SplashState {}

final class SplashLoading extends SplashState {}

final class SplashSuccess extends SplashState {
  final DoctorEntity? doctorEntity;
  const SplashSuccess({this.doctorEntity});
}

final class SplashError extends SplashState {}
