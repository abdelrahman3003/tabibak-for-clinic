part of 'clinic_layout_bloc.dart';

sealed class ClinicLayoutEvent extends Equatable {
  const ClinicLayoutEvent();

  @override
  List<Object> get props => [];
}

class GetClinicInfoEvent extends ClinicLayoutEvent {
  const GetClinicInfoEvent();
}
