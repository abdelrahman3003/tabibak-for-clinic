import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/usecase/update_doctor_info_use_case.dart';

part 'doctor_info_event.dart';
part 'doctor_info_state.dart';

class DoctorInfoBloc extends Bloc<DoctorInfoEvent, DoctorInfoState> {
  final UpdateDoctorInfoUseCase updateDoctorInfoUseCase;
  DoctorInfoBloc(this.updateDoctorInfoUseCase) : super(DoctorInfoInitial()) {
    on<UpdateDoctorInfo>((event, emit) async {
      emit(DoctorInfoLoading());
      final result = await updateDoctorInfoUseCase.call(
          name: event.name,
          address: event.address,
          phone: event.phone,
          bio: event.bio);
      result.fold(
        (error) {
          emit(DoctorInfoFailed(errorMessage: error.message!));
        },
        (success) {
          emit(DoctorInfoSuccess());
        },
      );
    });
  }
}
