part of 'splash_bloc.dart';

sealed class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

class CheckDoctorEvent extends SplashEvent {
  final User? user;
  const CheckDoctorEvent({required this.user});
}
