import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/create_clinic_info_use_case.dart';

part 'clinic_info_event.dart';
part 'clinic_info_state.dart';

class ClinicInfoBloc extends Bloc<ClinicInfoEvent, ClinicInfoState> {
  final CreateClinicInfoUseCase createClinicInfoUseCase;

  ClinicInfoBloc(this.createClinicInfoUseCase) : super(ClinicInfoInitial()) {
    on<CreateClinicInfoEvent>((event, emit) async {
      emit(ClinicInfoLoading());
      final result = await createClinicInfoUseCase.call(event.clinicInfoEntity);
      result.fold(
        (error) {
          emit(ClinicInfoFailed(errorMEssage: error.message!));
        },
        (id) {
          emit(ClinicInfoSuccess());
        },
      );
    });
  }
}
