import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/usecase/get_doctor_use_case.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/usecase/upload_image_profile_use_case.dart';

part 'doctor_profile_event.dart';
part 'doctor_profile_state.dart';

class DoctorProfileBloc extends Bloc<DoctorProfileEvent, DoctorProfileState> {
  final GetDoctorUseCase getDoctorUseCase;
  final UploadImageProfileUseCase uploadImageProfileUseCase;
  DoctorProfileBloc(this.getDoctorUseCase, this.uploadImageProfileUseCase)
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
    add(GetDoctorProfileEvent());
  }
}
