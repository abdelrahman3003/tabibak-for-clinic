import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_canceled_appointments_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_finished_appointments_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_upcoming_appointments_use_case.dart';

part 'appointment_type_event.dart';
part 'appointment_type_state.dart';

class AppointmentTypeBloc
    extends Bloc<AppointmentTypeEvent, AppointmentTypeState> {
  final GetUpcomingAppointmentsUseCase getUpcomingAppointmentsUseCase;
  final GetFinishedAppointmentsUseCase getFinishedAppointmentsUseCase;
  final GetCanceledAppointmentsUseCase getCanceledAppointmentsUseCase;
  AppointmentTypeBloc(this.getUpcomingAppointmentsUseCase,
      this.getFinishedAppointmentsUseCase, this.getCanceledAppointmentsUseCase)
      : super(AppointmentTypeInitial()) {
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
          emit(FinishedAppointmentsSuccess(upcomingList: list));
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
          emit(CanceledAppointmentsSuccess(upcomingList: list));
        },
      );
    });
    add(GetUpcomingAppointmentsEvent());
  }
}
