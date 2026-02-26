import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/send_otp_use_case.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final SendOtpUseCase sendOtpUseCase;

  ForgotPasswordBloc(this.sendOtpUseCase) : super(ForgotPasswordInitial()) {
    on<SendOtpEvent>((event, emit) async {
      final result = await sendOtpUseCase.call(event.email);
      result.fold(
        (error) {
          emit(ForgotPasswordFailure(errorMessage: error.message!));
        },
        (_) {
          emit(ForgotPasswordSuccess());
        },
      );
    });
  }
}
