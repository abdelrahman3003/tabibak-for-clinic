import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabibak_for_clinic/core/functions/pick_image.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/usecases/add_doctor_use_case.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/doctor_entity.dart';

part 'license_event.dart';
part 'license_state.dart';

class LicenseBloc extends Bloc<LicenseEvent, LicenseState> {
  final AddDoctorUseCase addDoctorUseCase;

  LicenseBloc({required this.addDoctorUseCase}) : super(LicenseInitial()) {
    on<UploadFileEvent>((event, emit) async {
      final file = await pickImage();
      if (file != null) {
        emit(UploadFileSuccess(file: file));
      }
    });
    on<AddDoctorEvent>((event, emit) async {
      emit(LicenseLoading());
      final result = await addDoctorUseCase.call(event.doctorEntity);
      result.fold(
        (error) {
          emit(LicenseError(errorMessage: error.message!));
        },
        (_) => emit(LicenseSuccess()),
      );
    });
  }
}
