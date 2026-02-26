import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/verified_code_use_case.dart';

part 'verify_code_event.dart';
part 'verify_code_state.dart';

class VerifyCodeBloc extends Bloc<VerifyCodeEvent, VerifyCodeState> {
  final VerifiedCodeUseCase verifiedCodeUseCase;
  VerifyCodeBloc(this.verifiedCodeUseCase) : super(VerifyCodeInitial()) {
    on<VerifyCodeEvent>((event, emit) async {
      final result =
          await verifiedCodeUseCase.call(email: event.email, otp: event.otp);
      result.fold(
        (error) {
          emit(VerifyCodeFailure(errorMessage: error.message!));
        },
        (_) {
          emit(VerifyCodeSuccess());
        },
      );
    });
  }
}
