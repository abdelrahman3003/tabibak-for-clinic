import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/create_clinic_working_day_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_days_use_case.dart';

part 'clinic_working_day_event.dart';
part 'clinic_working_day_state.dart';

class ClinicWorkingDayBloc
    extends Bloc<ClinicWorkingDayEvent, ClinicWorkingDayState> {
  final CreateClinicWorkingDayUseCase clinicWorkingDayUseCase;
  final GetDaysUseCase getDaysUseCase;
  ClinicWorkingDayBloc(
      {required this.clinicWorkingDayUseCase, required this.getDaysUseCase})
      : super(ClinicWorkingDayInitial()) {
    on<CreateClinicWorkingDayEvent>((event, emit) async {
      emit(ClinicWorkingDayLoading());

      final result =
          await clinicWorkingDayUseCase.call(event.clinicWorkingDayEntity);
      result.fold(
        (error) {
          emit(ClinicWorkingDayFailed(errorMessage: error.message!));
        },
        (id) {
          emit(ClinicWorkingDaySuccess());
        },
      );
    });
    on<GetAllDaysEvent>((event, emit) async {
      emit(GetAllDaysLoading());
      final result = await getDaysUseCase.call();
      result.fold(
        (error) {},
        (days) {
          emit(GetAllDaysSuccess(days: days));
        },
      );
    });
    add(GetAllDaysEvent());
  }
}
