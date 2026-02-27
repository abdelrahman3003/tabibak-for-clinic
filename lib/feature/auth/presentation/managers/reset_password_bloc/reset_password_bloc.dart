import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/reset_password_use_case.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordUseCase resetPasswordUseCase;
  ResetPasswordBloc(this.resetPasswordUseCase) : super(ResetPasswordInitial()) {
    on<ResetEvent>((event, emit) async {
      emit(ResetPasswordLoading());

      final result = await resetPasswordUseCase.call(event.newPassword);
      result.fold(
        (error) {
          emit(ResetPasswordFailure(errorMessage: error.message!));
        },
        (_) {
          emit(ResetPasswordSuccess());
        },
      );
    });
  }
}
