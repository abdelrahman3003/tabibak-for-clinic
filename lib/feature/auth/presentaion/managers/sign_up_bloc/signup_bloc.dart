import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak_for_clinic/core/functions/pick_image.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/specialty_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/get_specialties_usecase.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/sign_up_usecase.dart';

part 'signup_event.dart';
part 'signup_state.dart';

extension SignupRequestedWorkDayShiftsExtension on SignupRequested {
  dynamic get workDayShifts => <dynamic>[];
}

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignUpUsecase signUpUsecase;
  final GetSpecialtiesUsecase getSpecialtiesUsecase;

  SignupBloc({
    required this.signUpUsecase,
    required this.getSpecialtiesUsecase,
  }) : super(SignupInitial()) {
    on<GetSpecialtiesRequested>(
      (event, emit) async {
        final result = await getSpecialtiesUsecase.call();
        result.fold(
          (l) {},
          (specialties) =>
              emit(GetSpecialtiesRequestedSuccess(specialties: specialties)),
        );
      },
    );
    on<SignupRequested>((event, emit) async {
      emit(SignupLoading());
      final result = await signUpUsecase.call(
          doctorEntity: event.doctorEntity, password: event.password);
      result.fold(
        (error) =>
            emit(SignupError(errorMessage: error.message ?? 'Unknown Error')),
        (r) => emit(SignupSuccess()),
      );
    });
    on<UploadFileEvent>((event, emit) async {
      final file = await pickImage();
      if (file != null) {
        emit(UploadFileSuccess(file: file));
      }
    });

    add(const GetSpecialtiesRequested());
  }
}
