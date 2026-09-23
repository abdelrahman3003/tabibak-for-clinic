import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_appointments_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/update_appointment_status_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/appoinment/appointment_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/all_appointment_screen/appointment_list_view.dart';

part 'all_appointments_event.dart';
part 'all_appointments_state.dart';

class AllAppointmentsBloc
    extends Bloc<AllAppointmentsEvent, AllAppointmentsState> {
  final GetAppointmentsUseCase getAppointmentsUseCase;
  final UpdateAppointmentStatusUseCase updateAppointmentStatusUseCase;
  final AppointmentBloc appointmentBloc;
  List<AppointmentEntity> upcomingList = [];
  List<AppointmentEntity> finishedList = [];
  List<AppointmentEntity> canceledList = [];
  int currentIndex = 0;
  String searchName = '';
  List<AppointmentEntity>? searchResults;
  int _searchRequestId = 0;

  AllAppointmentsBloc(
    this.getAppointmentsUseCase,
    this.updateAppointmentStatusUseCase,
    this.appointmentBloc,
  ) : super(AllAppointmentsInitial()) {
    on<GetUpcomingAppointmentsEvent>((event, emit) async {
      emit(AllAppointmentsLoading(AppointmentType.upcoming));
      final result = await getAppointmentsUseCase.call(
          status: AppointmentStatus.pending.id);
      result.fold(
        (error) => emit(
            AllAppointmentsFailure(error.message!, AppointmentType.upcoming)),
        (appointments) {
          upcomingList = _sortAppointments(appointments ?? [], ascending: true);
          emit(AllAppointmentsSuccess(upcomingList, AppointmentType.upcoming));
        },
      );
    });

    on<GetFinishedAppointmentsEvent>((event, emit) async {
      emit(AllAppointmentsLoading(AppointmentType.finished));
      final result = await getAppointmentsUseCase.call(
          status: AppointmentStatus.confirmed.id);
      result.fold(
        (error) => emit(
            AllAppointmentsFailure(error.message!, AppointmentType.finished)),
        (appointments) {
          finishedList = _sortAppointments(appointments ?? [], ascending: false);
          emit(AllAppointmentsSuccess(finishedList, AppointmentType.finished));
        },
      );
    });

    on<GetCanceledAppointmentsEvent>((event, emit) async {
      emit(AllAppointmentsLoading(AppointmentType.canceled));
      final result = await getAppointmentsUseCase.call(
          status: AppointmentStatus.cancelled.id);
      result.fold(
        (error) => emit(
            AllAppointmentsFailure(error.message!, AppointmentType.canceled)),
        (appointments) {
          canceledList = _sortAppointments(appointments ?? [], ascending: false);
          emit(AllAppointmentsSuccess(canceledList, AppointmentType.canceled));
        },
      );
    });

    on<RefreshAllAppointmentsEvent>((event, emit) async {
      emit(AllAppointmentsRefreshing());
      await _refreshLists();
      appointmentBloc.add(const GetAppointmentEvent());
      emit(AllAppointmentsRefreshed());
    });

    on<SearchAppointmentsEvent>((event, emit) async {
      searchName = event.name.trim();
      final requestId = ++_searchRequestId;
      final type = AppointmentType.values[currentIndex];
      emit(AllAppointmentsLoading(type));
      final status = switch (type) {
        AppointmentType.upcoming => AppointmentStatus.pending.id,
        AppointmentType.finished => AppointmentStatus.confirmed.id,
        AppointmentType.canceled => AppointmentStatus.cancelled.id,
      };
      final result = await getAppointmentsUseCase.call(
        status: status,
        name: searchName.isEmpty ? null : searchName,
      );
      if (requestId != _searchRequestId) return;
      result.fold(
        (error) {
          searchResults = null;
          emit(AllAppointmentsFailure(error.message!, type));
        },
        (appointments) {
          final matchingAppointments = (appointments ?? []).where((appointment) {
            final appointmentName = appointment.name?.trim().toLowerCase() ?? '';
            return appointmentName.contains(searchName.toLowerCase());
          }).toList();
          searchResults = _sortAppointments(matchingAppointments,
              ascending: type == AppointmentType.upcoming);
          emit(AllAppointmentsSuccess(searchResults!, type));
        },
      );
    });

    on<UpdateAppointmentStatusEvent>((event, emit) async {
      emit(UpdateAppointmentStatusLoading(
          loadingKey: "${event.appointmentId}-${event.statusIndex}"));
      final result = await updateAppointmentStatusUseCase.call(
        statusIndex: event.statusIndex,
        appointmentId: event.appointmentId,
      );

      await result.fold(
        (error) async => emit(UpdateAppointmentStatusFailure(error.message!)),
        (_) async {
          emit(AllAppointmentsRefreshing());
          await _refreshLists();
          appointmentBloc.add(const GetAppointmentEvent());
          emit(UpdateAppointmentStatusSuccess());
          emit(AllAppointmentsRefreshed());
        },
      );
    });

    on<ChangeTabEvent>((event, emit) {
      currentIndex = event.index;
      emit(ToggleIndexState(event.index));
    });
  }

  Future<void> _refreshLists() async {
    final results = await Future.wait([
      getAppointmentsUseCase.call(status: AppointmentStatus.pending.id),
      getAppointmentsUseCase.call(status: AppointmentStatus.confirmed.id),
      getAppointmentsUseCase.call(status: AppointmentStatus.cancelled.id),
    ]);
    results[0].fold((_) {}, (appointments) {
      upcomingList = _sortAppointments(appointments ?? [], ascending: true);
    });
    results[1].fold((_) {}, (appointments) {
      finishedList = _sortAppointments(appointments ?? [], ascending: false);
    });
    results[2].fold((_) {}, (appointments) {
      canceledList = _sortAppointments(appointments ?? [], ascending: false);
    });
  }

  List<AppointmentEntity> _sortAppointments(
    List<AppointmentEntity> appointments, {
    required bool ascending,
  }) {
    final sortedAppointments = List<AppointmentEntity>.of(appointments);
    sortedAppointments.sort((first, second) {
      final firstDate = first.appointmentDate;
      final secondDate = second.appointmentDate;
      if (firstDate == null) return secondDate == null ? 0 : 1;
      if (secondDate == null) return -1;
      final order = firstDate.compareTo(secondDate);
      return ascending ? order : -order;
    });
    return sortedAppointments;
  }
}
