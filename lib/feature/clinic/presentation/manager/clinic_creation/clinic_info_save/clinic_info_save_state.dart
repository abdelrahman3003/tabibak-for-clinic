part of 'clinic_info_save_bloc.dart';

sealed class ClinicInfoSaveState extends Equatable {
  const ClinicInfoSaveState();

  @override
  List<Object> get props => [];
}

final class ClinicInfoSaveInitial extends ClinicInfoSaveState {}

final class ClinicInfoSaveLoading extends ClinicInfoSaveState {}

final class ClinicInfoSaveSuccess extends ClinicInfoSaveState {}

final class ClinicInfoSaveFailure extends ClinicInfoSaveState {
  final String errorMessage;
  const ClinicInfoSaveFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
