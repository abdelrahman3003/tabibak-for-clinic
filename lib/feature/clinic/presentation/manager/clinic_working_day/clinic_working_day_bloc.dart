import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_working_day_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_days_use_case.dart';

part 'clinic_working_day_event.dart';
part 'clinic_working_day_state.dart';

class ClinicWorkingDayBloc
    extends Bloc<ClinicWorkingDayEvent, ClinicWorkingDayState> {
  final GetDaysUseCase getDaysUseCase;
  ClinicWorkingDayBloc({required this.getDaysUseCase})
      : super(ClinicWorkingDayInitial()) {
    on<GetAllDaysEvent>((event, emit) async {
      emit(GetAllDaysLoading());
      final result = await getDaysUseCase.call();
      result.fold(
        (error) {},
        (days) {
          emit(GetAllDaysSuccess(days: _mapDaysToWorkingDays(days)));
        },
      );
    });
    add(GetAllDaysEvent());
  }
}

List<ClinicWorkingDayModel> _mapDaysToWorkingDays(
  List<ClinicDayEntity> days,
) {
  return days.map((day) {
    return ClinicWorkingDayModel(clinicDayEntity: day);
  }).toList();
}
