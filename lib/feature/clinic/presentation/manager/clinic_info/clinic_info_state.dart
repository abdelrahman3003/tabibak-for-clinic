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

final class GetCitiesSuccess extends ClinicInfoState {
  final List<CityEntity> cities;

  const GetCitiesSuccess({required this.cities});
}

final class GetGovernoratesSuccess extends ClinicInfoState {
  final List<GovernorateEntity> governorates;

  const GetGovernoratesSuccess({required this.governorates});
}

final class GetMarkazSuccess extends ClinicInfoState {
  final List<CityEntity> cities;

  const GetMarkazSuccess({required this.cities});
}

final class GetVillagesSuccess extends ClinicInfoState {
  final List<CityEntity> cities;

  const GetVillagesSuccess({required this.cities});
}
