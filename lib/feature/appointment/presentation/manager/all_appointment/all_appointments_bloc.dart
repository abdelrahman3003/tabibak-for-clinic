import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_appointments_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/update_appointment_status_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/view/widget/all_appointment_screen/appointment_list_view.dart';

part 'all_appointments_event.dart';
part 'all_appointments_state.dart';

class AllAppointmentsBloc
    extends Bloc<AllAppointmentsEvent, AllAppointmentsState> {
  final GetAppointmentsUseCase getAppointmentsUseCase;
  final UpdateAppointmentStatusUseCase updateAppointmentStatusUseCase;

  // ✅ Each tab keeps its own list independently
  List<AppointmentEntity> upcomingList = [];
  List<AppointmentEntity> finishedList = [];
  List<AppointmentEntity> canceledList = [];
  int currentIndex = 0;

  AllAppointmentsBloc(
    this.getAppointmentsUseCase,
    this.updateAppointmentStatusUseCase,
  ) : super(AllAppointmentsInitial()) {
    on<GetUpcomingAppointmentsEvent>((event, emit) async {
      emit(AllAppointmentsLoading(AppointmentType.upcoming));
      final result = await getAppointmentsUseCase.call(type: 1);
      result.fold(
        (error) => emit(
            AllAppointmentsFailure(error.message!, AppointmentType.upcoming)),
        (appointments) {
          upcomingList = appointments ?? [];
          emit(AllAppointmentsSuccess(upcomingList, AppointmentType.upcoming));
        },
      );
    });

    on<GetFinishedAppointmentsEvent>((event, emit) async {
      emit(AllAppointmentsLoading(AppointmentType.finished));
      final result = await getAppointmentsUseCase.call(type: 5);
      result.fold(
        (error) => emit(
            AllAppointmentsFailure(error.message!, AppointmentType.finished)),
        (appointments) {
          finishedList = appointments ?? [];
          emit(AllAppointmentsSuccess(finishedList, AppointmentType.finished));
        },
      );
    });

    on<GetCanceledAppointmentsEvent>((event, emit) async {
      emit(AllAppointmentsLoading(AppointmentType.canceled));
      final result = await getAppointmentsUseCase.call(type: 3);
      result.fold(
        (error) => emit(
            AllAppointmentsFailure(error.message!, AppointmentType.canceled)),
        (appointments) {
          canceledList = appointments ?? [];
          emit(AllAppointmentsSuccess(canceledList, AppointmentType.canceled));
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
      result.fold(
        (error) => emit(UpdateAppointmentStatusFailure(error.message!)),
        (_) {
          emit(UpdateAppointmentStatusSuccess());
          add(GetUpcomingAppointmentsEvent());
        },
      );
    });

    on<ChangeTabEvent>((event, emit) {
      currentIndex = event.index;
      emit(ToggleIndexState(event.index));
    });
  }
}
