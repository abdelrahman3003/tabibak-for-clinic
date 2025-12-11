import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/save_clinic_info_use_case.dart';

part 'clinic_info_save_event.dart';
part 'clinic_info_save_state.dart';

class ClinicInfoSaveBloc
    extends Bloc<ClinicInfoSaveEvent, ClinicInfoSaveState> {
  final SaveClinicInfoUseCase saveClinicInfoUseCase;
  ClinicInfoSaveBloc(this.saveClinicInfoUseCase)
      : super(ClinicInfoSaveInitial()) {
    on<SaveClinicInfoEvent>((event, emit) async {
      emit(ClinicInfoSaveLoading());
      final result = await saveClinicInfoUseCase.call(event.clinicInfoEntity);
      result.fold(
        (error) {
          emit(ClinicInfoSaveFailure(errorMessage: error.message!));
        },
        (success) {
          emit(ClinicInfoSaveSuccess());
        },
      );
    });
  }
}
