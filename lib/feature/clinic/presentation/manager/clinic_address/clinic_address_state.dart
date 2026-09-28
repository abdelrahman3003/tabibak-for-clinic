part of 'clinic_address_bloc.dart';

sealed class ClinicAddressState extends Equatable {
  const ClinicAddressState();

  @override
  List<Object> get props => [];
}

final class ClinicAddressInitial extends ClinicAddressState {}

final class ClinicAddressLoading extends ClinicAddressState {}

final class ClinicAddressFailed extends ClinicAddressState {
  final String errorMessage;

  const ClinicAddressFailed({required this.errorMessage});
}

final class ClinicAddressSuccess extends ClinicAddressState {}

final class GetCitiesSuccess extends ClinicAddressState {
  final List<CityEntity> cities;

  const GetCitiesSuccess({required this.cities});
}

final class GetGovernoratesSuccess extends ClinicAddressState {
  final List<GovernorateEntity> governorates;

  const GetGovernoratesSuccess({required this.governorates});
}

final class GetMarkazSuccess extends ClinicAddressState {
  final List<CityEntity> cities;

  const GetMarkazSuccess({required this.cities});
}

final class GetVillagesSuccess extends ClinicAddressState {
  final List<CityEntity> cities;

  const GetVillagesSuccess({required this.cities});
}
