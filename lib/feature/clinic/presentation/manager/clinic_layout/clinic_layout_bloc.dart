import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_working_day_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_clinic_info_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_clinic_working_day_shift_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/toggle_clinic_available_use_case.dart';
import 'package:tabibak_for_clinic/core/helper/shared_pref_helper.dart';

part 'clinic_layout_event.dart';
part 'clinic_layout_state.dart';

class ClinicLayoutBloc extends Bloc<ClinicLayoutEvent, ClinicLayoutState> {
  final GetClinicInfoUseCase getClinicInfoUseCase;
  final GetClinicWorkingDayShiftUseCase getClinicWorkingDayShiftUseCase;
  final ToggleClinicAvailableUseCase toggleClinicAvailableUseCase;
  final SharedPrefHelper sharedPrefHelper;

  ClinicLayoutBloc(this.getClinicInfoUseCase,
      this.getClinicWorkingDayShiftUseCase, this.toggleClinicAvailableUseCase,
      this.sharedPrefHelper)
      : super(ClinicLayoutInitial()) {
    on<GetClinicInfoEvent>((event, emit) async {
      emit(ClinicLayoutLoading());
      final result = await getClinicInfoUseCase.call();
      await result.fold(
        (error) async {},
        (list) async {
          if (list.isEmpty) {
            emit(ClinicLayoutEmpty());
          } else {
            final savedId = sharedPrefHelper.getInt(SharedPrefKeys.currentClinicId);
            final clinic = list.firstWhere(
              (item) => item.id == savedId,
              orElse: () => list.first,
            );
            if (clinic.id != savedId) {
              await sharedPrefHelper.setData(
                key: SharedPrefKeys.currentClinicId,
                value: clinic.id!,
              );
            }
            final result2 =
                await getClinicWorkingDayShiftUseCase.call(clinic.id!);
            await result2.fold(
                (error) async =>
                    emit(ClinicLayoutFailed(errorMessage: error.message!)),
                (workingShiftsDays) async {
              emit(
                ClinicLayoutSuccess(
                  clinicInfoEntity: clinic,
                  workingShiftsDays: workingShiftsDays,
                ),
              );
            });
          }
        },
      );
    });
    on<ToggleClinicAvailableEvent>((event, emit) async {
      emit(ClinicAvailableLoading());
      final result = await toggleClinicAvailableUseCase.call(
          clinicId: event.clinicId, isAvailable: event.isAvailable);
      result.fold(
        (error) {
          emit(ClinicAvailableFailed(errorMessage: error.message!));
        },
        (id) {
          emit(ClinicAvailableSuccess());
        },
      );
    });
    add(const GetClinicInfoEvent());
  }
}
