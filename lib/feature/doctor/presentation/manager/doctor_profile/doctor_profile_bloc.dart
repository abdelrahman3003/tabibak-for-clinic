import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/usecase/get_doctor_use_case.dart';

part 'doctor_profile_event.dart';
part 'doctor_profile_state.dart';

class DoctorProfileBloc extends Bloc<DoctorProfileEvent, DoctorProfileState> {
  final GetDoctorUseCase getDoctorUseCase;
  DoctorProfileBloc(this.getDoctorUseCase) : super(DoctorProfileInitial()) {
    on<GetDoctorProfileEvent>((event, emit) async {
      emit(DoctorProfileLoading());
      final result = await getDoctorUseCase.call();
      result.fold(
        (error) {
          emit(DoctorProfileFailed(errorMessage: error.message!));
        },
        (doctor) {
          emit(DoctorProfileSuccess(doctorEntity: doctor));
        },
      );
    });
    add(GetDoctorProfileEvent());
  }
}
