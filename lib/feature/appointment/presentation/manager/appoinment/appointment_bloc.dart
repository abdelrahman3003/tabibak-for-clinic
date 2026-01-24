import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_status_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_appointments_home_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_canceled_appointments_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_finished_appointments_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_upcoming_appointments_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/update_appointment_status_use_case.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetAppointmentsUseCase getAppointmentsUseCase;
  final UpdateAppointmentStatusUseCase updateAppointmentStatusUseCase;
  final GetUpcomingAppointmentsUseCase getUpcomingAppointmentsUseCase;
  final GetFinishedAppointmentsUseCase getFinishedAppointmentsUseCase;
  final GetCanceledAppointmentsUseCase getCanceledAppointmentsUseCase;
  List<AppointmentStatusEntity>? appointmentStatusList;
  AppointmentBloc(
    this.getAppointmentsUseCase,
    this.updateAppointmentStatusUseCase,
    this.getUpcomingAppointmentsUseCase,
    this.getFinishedAppointmentsUseCase,
    this.getCanceledAppointmentsUseCase,
  ) : super(AppointmentInitial()) {
    on<GetAppointmentEvent>((event, emit) async {
      if (event.isUpdate) {
        emit(AppointmentLoading());
      }
      final result = await getAppointmentsUseCase.call();
      result.fold(
        (error) {
          emit(AppointmentFailed(errorMessage: error.message!));
        },
        (appointmentHomeEntity) {
          appointmentStatusList = appointmentHomeEntity.appointmentStatusList;
          emit(AppointmentSuccess(
              appointmentTodayEntity:
                  appointmentHomeEntity.appointmentTodayList!));
        },
      );
    });
    on<UpdateAppointmentStatusEvent>((event, emit) async {
      emit(UpdateAppointmentStatusLoading());
      final result = await updateAppointmentStatusUseCase.call(
          statusIndex: event.statusIndex,
          appointmentId: event.appointmentId,
          type: event.type,
          isToday: event.isToday);
      result.fold(
        (error) {
          emit(UpdateAppointmentStatusFailed(errorMessage: error.message!));
        },
        (appointmentsList) {
          add(const GetAppointmentEvent());
          emit(UpdateAppointmentStatusSuccess(
            updatedAppointmentList: appointmentsList,
          ));
        },
      );
    });
    on<GetUpcomingAppointmentsEvent>((event, emit) async {
      emit(UpcomingAppointmentsLoading());

      final result = await getUpcomingAppointmentsUseCase.call();
      result.fold(
        (error) {
          emit(UpcomingAppointmentsFailed(errorMessage: error.message!));
        },
        (list) {
          emit(UpcomingAppointmentsSuccess(upcomingList: list));
        },
      );
    });
    on<GetFinishedAppointmentsEvent>((event, emit) async {
      emit(FinishedAppointmentsLoading());

      final result = await getFinishedAppointmentsUseCase.call();
      result.fold(
        (error) {
          emit(FinishedAppointmentsFailed(errorMessage: error.message!));
        },
        (list) {
          emit(FinishedAppointmentsSuccess(finishedList: list));
        },
      );
    });
    on<GetCanceledAppointmentsEvent>((event, emit) async {
      emit(CanceledAppointmentsLoading());

      final result = await getCanceledAppointmentsUseCase.call();
      result.fold(
        (error) {
          emit(CanceledAppointmentsFailed(errorMessage: error.message!));
        },
        (list) {
          emit(CanceledAppointmentsSuccess(canceledList: list));
        },
      );
    });
    add(const GetAppointmentEvent());
  }
}
