import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/signin_result_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/sign_in_usecase.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/sign_in_with_googl_usecase.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final SignInUsecase signInUsecase;
  final SignInWithGooglUsecase signInWithGooglUsecase;
  SigninBloc(
      {required this.signInUsecase, required this.signInWithGooglUsecase})
      : super(SigninInitial()) {
    on<SignInRequestedEvent>((event, emit) async {
      emit(SigninLoading());
      final result = await signInUsecase.call(event.email, event.password);
      result.fold((error) {
        emit(SigninError(errorMessage: error.message!));
      }, (right) {
        emit(SigninSuccess());
      });
    });
    on<SignInWithGoogleEvent>((event, emit) async {
      emit(SigninWithGoogleLoading());
      final result = await signInWithGooglUsecase.call();
      result.fold((error) {
        emit(SigninWithGoogleError(errorMessage: error.message!));
      }, (result) {
        emit(SigninWithGoogleSuccess(signinResultEntity: result));
      });
    });
  }
}
