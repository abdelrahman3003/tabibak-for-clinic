import 'package:bloc/bloc.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/doctor_service_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/delete_doctor_service_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/get_doctor_services_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/usecases/save_doctor_service_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/doctor_services/doctor_services_event.dart';
import 'package:tabibak_for_clinic/feature/clinic/presentation/manager/doctor_services/doctor_services_state.dart';

class DoctorServicesBloc
    extends Bloc<DoctorServicesEvent, DoctorServicesState> {
  final GetDoctorServicesUseCase getDoctorServicesUseCase;
  final SaveDoctorServiceUseCase saveDoctorServiceUseCase;
  final DeleteDoctorServiceUseCase deleteDoctorServiceUseCase;

  List<DoctorServiceEntity> _services = [];
  List<DoctorServiceEntity> get services => _services;

  DoctorServicesBloc({
    required this.getDoctorServicesUseCase,
    required this.saveDoctorServiceUseCase,
    required this.deleteDoctorServiceUseCase,
  }) : super(DoctorServicesInitial()) {
    on<GetDoctorServicesEvent>((event, emit) async {
      emit(DoctorServicesLoading());
      final result =
          await getDoctorServicesUseCase.call(clinicId: event.clinicId);
      result.fold(
        (error) => emit(DoctorServicesError(
            errorMessage: error.message ?? 'Failed to load services')),
        (services) {
          _services = services;
          emit(DoctorServicesLoaded(services: _services));
        },
      );
    });

    on<SaveDoctorServiceEvent>((event, emit) async {
      emit(DoctorServicesActionLoading());
      final result = await saveDoctorServiceUseCase.call(
          serviceEntity: event.serviceEntity);
      await result.fold(
        (error) async => emit(DoctorServicesError(
            errorMessage: error.message ?? 'Failed to save service')),
        (savedService) async {
          emit(const DoctorServicesActionSuccess(isDelete: false));
          final refreshResult =
              await getDoctorServicesUseCase.call(clinicId: event.clinicId);
          refreshResult.fold(
            (err) => emit(DoctorServicesLoaded(services: _services)),
            (services) {
              _services = services;
              emit(DoctorServicesLoaded(services: _services));
            },
          );
        },
      );
    });

    on<DeleteDoctorServiceEvent>((event, emit) async {
      emit(DoctorServicesActionLoading());
      final result =
          await deleteDoctorServiceUseCase.call(serviceId: event.serviceId);
      await result.fold(
        (error) async => emit(DoctorServicesError(
            errorMessage: error.message ?? 'Failed to delete service')),
        (_) async {
          emit(const DoctorServicesActionSuccess(isDelete: true));
          final refreshResult =
              await getDoctorServicesUseCase.call(clinicId: event.clinicId);
          refreshResult.fold(
            (err) => emit(DoctorServicesLoaded(services: _services)),
            (services) {
              _services = services;
              emit(DoctorServicesLoaded(services: _services));
            },
          );
        },
      );
    });
  }
}
