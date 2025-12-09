import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_clinic_info_use_case.dart';

part 'clinic_layout_event.dart';
part 'clinic_layout_state.dart';

class ClinicLayoutBloc extends Bloc<ClinicLayoutEvent, ClinicLayoutState> {
  final GetClinicInfoUseCase getClinicInfoUseCase;

  ClinicLayoutBloc(this.getClinicInfoUseCase) : super(ClinicLayoutInitial()) {
    on<GetClinicInfoEvent>((event, emit) async {
      emit(ClinicLayoutLoading());
      final result = await getClinicInfoUseCase.call();
      result.fold(
        (error) {
          emit(ClinicLayoutFailed(errorMessage: error.message!));
        },
        (list) {
          if (list.isEmpty) {
            emit(ClinicLayoutEmpty());
          } else {
            emit(ClinicLayoutSuccess(clinicInfoEntity: list[0]));
          }
        },
      );
    });
    add(const GetClinicInfoEvent());
  }
}
