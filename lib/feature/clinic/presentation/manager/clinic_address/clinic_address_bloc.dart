import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_address_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/governorate_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_cities_by_governorate_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_cities_by_parent_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_cities_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_governorates_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/save_clinic_address_use_case.dart';

part 'clinic_address_event.dart';
part 'clinic_address_state.dart';

class ClinicAddressBloc extends Bloc<ClinicAddressEvent, ClinicAddressState> {
  final SaveClinicAddressUseCase saveClinicAddressUseCase;
  final GetCitiesUseCase getCitiesUseCase;
  final GetGovernoratesUseCase getGovernoratesUseCase;
  final GetCitiesByGovernorateUseCase getCitiesByGovernorateUseCase;
  final GetCitiesByParentUseCase getCitiesByParentUseCase;

  ClinicAddressBloc(
    this.saveClinicAddressUseCase,
    this.getCitiesUseCase,
    this.getGovernoratesUseCase,
    this.getCitiesByGovernorateUseCase,
    this.getCitiesByParentUseCase,
  ) : super(ClinicAddressInitial()) {
    on<SaveClinicAddressEvent>((event, emit) async {
      emit(ClinicAddressLoading());
      final result =
          await saveClinicAddressUseCase.call(event.clinicAddressEntity);
      result.fold(
        (error) {
          emit(ClinicAddressFailed(errorMessage: error.message!));
        },
        (success) {
          emit(ClinicAddressSuccess());
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
