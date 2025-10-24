import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/clinic_day_shift.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/clinic_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/university_entity.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/add_doctor_usecase.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/sign_up_usecase.dart';

part 'signup_event.dart';
part 'signup_state.dart';

/// Provide a fallback getter for `workDayShifts` on `SignupRequested` so
/// existing call sites (like the addDoctorUsecase call below) compile even
/// if the event doesn't define that getter yet.
/// The return type is dynamic to avoid strict static type mismatches; adapt
/// the type to the actual expected type if you add the field to the event.
extension SignupRequestedWorkDayShiftsExtension on SignupRequested {
  dynamic get workDayShifts => <dynamic>[];
}

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignUpUsecase signUpUsecase;
  final DoctorUsecase doctorUsecase;

  SignupBloc({required this.signUpUsecase, required this.doctorUsecase})
      : super(SignupInitial()) {
    on<SignupRequested>((event, emit) async {
      emit(SignupLoading());

      final addDoctorResult = await doctorUsecase.call(
        doctorEntity: DoctorEntity(
          name: event.name,
          phone: event.phone,
          image: event.image,
          bio: event.bio,
          specialty: event.specialty,
          nationalId: event.nationalId,
          medicalLiecense: event.medicalLiecense,
        ),
        clinicEntity: ClinicEntity(
          clinicName: event.clinicName,
          address: event.address,
          consultationFee: event.consultationFee,
          phoneNumber: event.clinicPhone,
          isBooking: true,
        ),
        universityEntity: UniversityEntity(
          universityName: event.universityName,
          graduationYear: event.graduationYear,
        ),
        workDayShifts: event.workDayShifts,
      );

      if (addDoctorResult.isLeft()) {
        final error = addDoctorResult.fold((l) => l, (r) => null);
        emit(SignupError(errorMessage: error?.message ?? 'Unknown Error'));
        return;
      }

      final signUpResult = await signUpUsecase.call(
          email: event.email, password: event.password);

      signUpResult.fold(
        (error) =>
            emit(SignupError(errorMessage: error.message ?? 'Unknown Error')),
        (r) => emit(SignupSuccess()),
      );
    });
  }
}
