import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_time_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/create_clinic_time_use_case.dart';

part 'clinic_time_event.dart';
part 'clinic_time_state.dart';

class ClinicTimeBloc extends Bloc<ClinicTimeEvent, ClinicTimeState> {
  final CreateClinicTimeUseCase createClinicTimeUseCase;
  ClinicTimeBloc(this.createClinicTimeUseCase) : super(ClinicTimeInitial()) {
    on<CreateClinicTimeEvent>((event, emit) async {
      emit(ClinicTimeLoading());
      final result = await createClinicTimeUseCase.call(event.clinicTimeEntity);
      result.fold(
        (error) {
          emit(ClinicTimeFailed(errorMessage: error.message!));
        },
        (id) {
          emit(ClinicTimeSuccess());
        },
      );
    });
  }
}
