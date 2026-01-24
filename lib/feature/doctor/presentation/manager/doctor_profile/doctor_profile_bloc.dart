import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/usecase/get_doctor_use_case.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/usecase/log_out_use_case.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/usecase/upload_image_profile_use_case.dart';

part 'doctor_profile_event.dart';
part 'doctor_profile_state.dart';

class DoctorProfileBloc extends Bloc<DoctorProfileEvent, DoctorProfileState> {
  final GetDoctorUseCase getDoctorUseCase;
  final UploadImageProfileUseCase uploadImageProfileUseCase;
  final LogOutUseCase logOutUseCase;
  DoctorProfileBloc(
      this.getDoctorUseCase, this.uploadImageProfileUseCase, this.logOutUseCase)
      : super(DoctorProfileInitial()) {
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
    on<UploadImageProfileEvent>((event, emit) async {
      emit(UploadImageProfileLoading());
      final result = await uploadImageProfileUseCase.call(event.imagePath);
      result.fold(
        (error) {},
        (doctor) {
          emit(UploadImageProfileSuccess());
        },
      );
    });
    on<LogOutDoctorEvent>((event, emit) async {
      emit(LogOutDoctorLoading());
      final result = await logOutUseCase.call();
      result.fold(
        (error) {
          emit(LogOutDoctorFailed(errorMessage: error.errors));
        },
        (doctor) {
          emit(LogOutDoctorSuccess());
        },
      );
    });
    add(GetDoctorProfileEvent());
  }
}
