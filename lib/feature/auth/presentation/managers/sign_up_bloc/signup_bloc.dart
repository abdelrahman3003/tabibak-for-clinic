import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/get_specialties_usecase.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/sign_up_usecase.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/specialty_entity.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignUpUsecase signUpUsecase;
  final GetSpecialtiesUsecase getSpecialtiesUsecase;

  SignupBloc({
    required this.signUpUsecase,
    required this.getSpecialtiesUsecase,
  }) : super(SignupInitial()) {
    on<SignupRequestedEvent>((event, emit) async {
      log("========${event.doctorEntity.email}");
      log("========${event.doctorEntity.name}");
      log("========${event.doctorEntity.specialty}");
      log("========${event.doctorEntity.image}");
      emit(SignupLoading());
      final result = await signUpUsecase.call(doctorEntity: event.doctorEntity);
      result.fold(
        (error) =>
            emit(SignupError(errorMessage: error.message ?? 'Unknown Error')),
        (result) => emit(SignupSuccess()),
      );
    });
    on<GetSpecialtiesEvent>(
      (event, emit) async {
        final result = await getSpecialtiesUsecase.call();
        result.fold(
          (l) {},
          (specialties) =>
              emit(GetSpecialtiesRequestedSuccess(specialties: specialties)),
        );
      },
    );
    add(const GetSpecialtiesEvent());
  }
}
