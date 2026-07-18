import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/create_clinic_info_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_cities_use_case.dart';

part 'clinic_info_event.dart';
part 'clinic_info_state.dart';

class ClinicInfoBloc extends Bloc<ClinicInfoEvent, ClinicInfoState> {
  final CreateClinicInfoUseCase createClinicInfoUseCase;
  final GetCitiesUseCase getCitiesUseCase;
  ClinicInfoBloc(this.createClinicInfoUseCase, this.getCitiesUseCase)
      : super(ClinicInfoInitial()) {
    on<CreateClinicInfoEvent>((event, emit) async {
      emit(ClinicInfoLoading());
      final result = await createClinicInfoUseCase.call(event.clinicInfoEntity);
      result.fold(
        (error) {
          emit(ClinicInfoFailed(errorMessage: error.message!));
        },
        (id) {
          emit(ClinicInfoSuccess(clinicId: id));
        },
      );
    });
    on<GetCitiesEvent>((event, emit) async {
      final result = await getCitiesUseCase.call();
      result.fold(
        (_) {},
        (cities) {
          emit(GetCitiesSuccess(cities: cities));
        },
      );
    });
  }
}
