part of 'clinic_layout_bloc.dart';

sealed class ClinicLayoutState extends Equatable {
  const ClinicLayoutState();

  @override
  List<Object> get props => [];
}

final class ClinicLayoutInitial extends ClinicLayoutState {}

final class ClinicLayoutLoading extends ClinicLayoutState {}

final class ClinicLayoutFailed extends ClinicLayoutState {
  final String errorMessage;

  const ClinicLayoutFailed({required this.errorMessage});
}

final class ClinicLayoutEmpty extends ClinicLayoutState {}

final class ClinicLayoutSuccess extends ClinicLayoutState {
  final ClinicInfoEntity clinicInfoEntity;

  const ClinicLayoutSuccess({required this.clinicInfoEntity});
}
