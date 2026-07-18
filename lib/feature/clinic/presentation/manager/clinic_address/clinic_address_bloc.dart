import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_address_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_cities_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/save_clinic_address_use_case.dart';

part 'clinic_address_event.dart';
part 'clinic_address_state.dart';

class ClinicAddressBloc extends Bloc<ClinicAddressEvent, ClinicAddressState> {
  final SaveClinicAddressUseCase saveClinicAddressUseCase;
  final GetCitiesUseCase getCitiesUseCase;
  ClinicAddressBloc(this.saveClinicAddressUseCase, this.getCitiesUseCase)
      : super(ClinicAddressInitial()) {
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
  }
}
