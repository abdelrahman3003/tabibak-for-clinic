part of 'signup_bloc.dart';

sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

final class SignupInitial extends SignupState {}

final class GetSpecialtiesRequestedSuccess extends SignupState {
  final List<SpecialtyEntity> specialties;

  const GetSpecialtiesRequestedSuccess({required this.specialties});
}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {}

final class SignupError extends SignupState {
  final String errorMessage;

  const SignupError({required this.errorMessage});
}

final class UploadFileSuccess extends SignupState {
  final XFile? file;

  const UploadFileSuccess({required this.file});
}
