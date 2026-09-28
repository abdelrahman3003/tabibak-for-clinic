import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/governorate_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/create_clinic_info_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_cities_by_governorate_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_cities_by_parent_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_cities_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_governorates_use_case.dart';

part 'clinic_info_event.dart';
part 'clinic_info_state.dart';

class ClinicInfoBloc extends Bloc<ClinicInfoEvent, ClinicInfoState> {
  final CreateClinicInfoUseCase createClinicInfoUseCase;
  final GetCitiesUseCase getCitiesUseCase;
  final GetGovernoratesUseCase getGovernoratesUseCase;
  final GetCitiesByGovernorateUseCase getCitiesByGovernorateUseCase;
  final GetCitiesByParentUseCase getCitiesByParentUseCase;

  ClinicInfoBloc(
    this.createClinicInfoUseCase,
    this.getCitiesUseCase,
    this.getGovernoratesUseCase,
    this.getCitiesByGovernorateUseCase,
    this.getCitiesByParentUseCase,
  ) : super(ClinicInfoInitial()) {
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
    on<GetGovernoratesEvent>((event, emit) async {
      final result = await getGovernoratesUseCase.call();
      result.fold(
        (_) {},
        (governorates) {
          emit(GetGovernoratesSuccess(governorates: governorates));
        },
      );
    });
    on<GetCitiesByGovernorateEvent>((event, emit) async {
      final result =
          await getCitiesByGovernorateUseCase.call(event.governorateId);
      result.fold(
        (_) {},
        (cities) {
          emit(GetMarkazSuccess(cities: cities));
        },
      );
    });
    on<GetCitiesByParentEvent>((event, emit) async {
      final result = await getCitiesByParentUseCase.call(event.parentId);
      result.fold(
        (_) {},
        (cities) {
          emit(GetVillagesSuccess(cities: cities));
        },
      );
    });
  }
}
