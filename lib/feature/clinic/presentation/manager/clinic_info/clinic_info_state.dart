part of 'clinic_info_bloc.dart';

sealed class ClinicInfoState extends Equatable {
  const ClinicInfoState();

  @override
  List<Object> get props => [];
}

final class ClinicInfoInitial extends ClinicInfoState {}

final class ClinicInfoLoading extends ClinicInfoState {}

final class ClinicInfoFailed extends ClinicInfoState {
  final String errorMessage;

  const ClinicInfoFailed({required this.errorMessage});
}

final class ClinicInfoSuccess extends ClinicInfoState {
  final int clinicId;

  const ClinicInfoSuccess({required this.clinicId});
}
