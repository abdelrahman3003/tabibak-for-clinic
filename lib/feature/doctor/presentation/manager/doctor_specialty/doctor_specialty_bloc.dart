import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/entities/specialty_entity.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/usecase/get_specialties_use_case.dart';
import 'package:tabibak_for_clinic/feature/doctor/domain/usecase/update_doctor_specialty_use_cae.dart';

part 'doctor_specialty_event.dart';
part 'doctor_specialty_state.dart';

class DoctorSpecialtyBloc
    extends Bloc<DoctorSpecialtyEvent, DoctorSpecialtyState> {
  final GetSpecialtiesUseCase getSpecialtiesUseCase;
  final UpdateDoctorSpecialtyUseCae updateDoctorSpecialtyUseCae;
  DoctorSpecialtyBloc(
      this.getSpecialtiesUseCase, this.updateDoctorSpecialtyUseCae)
      : super(DoctorSpecialtyInitial()) {
    on<GetSpecialtiesEvent>((event, emit) async {
      emit(DoctorGetSpecialtiesLoading());
      final result = await getSpecialtiesUseCase.call();
      result.fold(
        (error) {
          emit(DoctorGetSpecialtiesFailed(errorMessage: error.message!));
        },
        (specialties) {
          emit(DoctorGetSpecialtiesSuccess(specialties: specialties));
        },
      );
    });
    on<UpdateDoctorsSpecialtyEvent>((event, emit) async {
      emit(DoctorUpdateSpecialtyLoading());
      final result = await updateDoctorSpecialtyUseCae.call(
          specialtyId: event.specialtyId);
      result.fold(
        (error) {
          emit(DoctorUpdateSpecialtyFailed(errorMessage: error.message!));
        },
        (_) {
          emit(DoctorUpdateSpecialtySuccess());
        },
      );
    });
    add(GetSpecialtiesEvent());
  }
}
