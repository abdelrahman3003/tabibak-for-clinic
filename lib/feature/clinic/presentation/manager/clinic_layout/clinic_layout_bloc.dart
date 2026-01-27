import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_clinic_info_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_clinic_working_day_shift_use_case.dart';

part 'clinic_layout_event.dart';
part 'clinic_layout_state.dart';

class ClinicLayoutBloc extends Bloc<ClinicLayoutEvent, ClinicLayoutState> {
  final GetClinicInfoUseCase getClinicInfoUseCase;
  final GetClinicWorkingDayShiftUseCase getClinicWorkingDayShiftUseCase;

  ClinicLayoutBloc(
      this.getClinicInfoUseCase, this.getClinicWorkingDayShiftUseCase)
      : super(ClinicLayoutInitial()) {
    on<GetClinicInfoEvent>((event, emit) async {
      emit(ClinicLayoutLoading());
      final result = await getClinicInfoUseCase.call();
      await result.fold(
        (error) async => emit(ClinicLayoutFailed(errorMessage: error.message!)),
        (list) async {
          if (list.isEmpty) {
            emit(ClinicLayoutEmpty());
          } else {
            final result2 =
                await getClinicWorkingDayShiftUseCase.call(list[0].id!);
            await result2.fold(
                (error) async =>
                    emit(ClinicLayoutFailed(errorMessage: error.message!)),
                (workingShiftsDays) async {
              emit(
                ClinicLayoutSuccess(
                  clinicInfoEntity: list[0],
                  workingShiftsDays: workingShiftsDays,
                ),
              );
            });
          }
        },
      );
    });
    add(const GetClinicInfoEvent());
  }
}
