import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_file_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/education_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/usecase/get_doctor_certificates_use_case.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/usecase/update_doctor_education_use_case.dart';

part 'doctor_education_event.dart';
part 'doctor_education_state.dart';

class DoctorEducationBloc
    extends Bloc<DoctorEducationEvent, DoctorEducationState> {
  final UpdateDoctorEducationUseCase updateDoctorEducationUseCase;
  final GetDoctorCertificatesUseCase getDoctorCertificatesUseCase;
  DoctorEducationBloc(
      this.updateDoctorEducationUseCase, this.getDoctorCertificatesUseCase)
      : super(DoctorEducationInitial()) {
    on<GetDoctorCertificatesEvent>((event, emit) async {
      emit(DoctorCertificatesLoading());
      final result = await getDoctorCertificatesUseCase.call();
      result.fold(
        (error) {},
        (files) {
          emit(DoctorCertificatesSuccess(doctorFilesEntities: files));
        },
      );
    });
    on<UpdateDoctorEducationEvent>((event, emit) async {
      emit(DoctorEducationLoading());
      final result = await updateDoctorEducationUseCase.call(
          educationEntity: event.educationEntity, files: event.files);
      result.fold(
        (error) {
          emit(DoctorEducationFailed(errorMessage: error.message!));
        },
        (success) {
          emit(DoctorEducationSuccess());
        },
      );
    });
    add(const GetDoctorCertificatesEvent());
  }
}
