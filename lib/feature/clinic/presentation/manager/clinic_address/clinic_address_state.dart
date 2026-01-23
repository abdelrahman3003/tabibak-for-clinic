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
