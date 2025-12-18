part of 'doctor_info_bloc.dart';

sealed class DoctorInfoState extends Equatable {
  const DoctorInfoState();

  @override
  List<Object> get props => [];
}

final class DoctorInfoInitial extends DoctorInfoState {}

final class DoctorInfoLoading extends DoctorInfoState {}

final class DoctorInfoFailed extends DoctorInfoState {
  final String errorMessage;

  const DoctorInfoFailed({required this.errorMessage});
}

final class DoctorInfoSuccess extends DoctorInfoState {}
