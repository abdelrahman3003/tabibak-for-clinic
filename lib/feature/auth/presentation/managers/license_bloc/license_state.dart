part of 'license_bloc.dart';

sealed class LicenseState extends Equatable {
  const LicenseState();

  @override
  List<Object> get props => [];
}

final class LicenseInitial extends LicenseState {}

final class LicenseLoading extends LicenseState {}

final class LicenseError extends LicenseState {
  final String errorMessage;

  const LicenseError({required this.errorMessage});
}

final class LicenseSuccess extends LicenseState {}

final class UploadFileSuccess extends LicenseState {
  final XFile? file;

  const UploadFileSuccess({required this.file});
}
