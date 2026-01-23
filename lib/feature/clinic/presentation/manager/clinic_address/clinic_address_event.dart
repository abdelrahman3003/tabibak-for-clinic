part of 'clinic_address_bloc.dart';

sealed class ClinicAddressEvent extends Equatable {
  const ClinicAddressEvent();

  @override
  List<Object> get props => [];
}

class SaveClinicAddressEvent extends ClinicAddressEvent {
  final ClinicAddressEntity clinicAddressEntity;

  const SaveClinicAddressEvent({required this.clinicAddressEntity});
  @override
  List<Object> get props => [clinicAddressEntity];
}
