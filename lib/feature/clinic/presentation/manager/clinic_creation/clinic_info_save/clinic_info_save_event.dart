part of 'clinic_info_save_bloc.dart';

sealed class ClinicInfoSaveEvent extends Equatable {
  const ClinicInfoSaveEvent();

  @override
  List<Object> get props => [];
}

class SaveClinicInfoEvent extends ClinicInfoSaveEvent {
  final ClinicInfoEntity clinicInfoEntity;
  const SaveClinicInfoEvent({required this.clinicInfoEntity});

  @override
  List<Object> get props => [clinicInfoEntity];
}
