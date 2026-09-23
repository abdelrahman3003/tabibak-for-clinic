import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_appointment_details_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/set_appointment_follow_up_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/update_appointment_status_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/all_appointment/all_appointments_bloc.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/appoinment/appointment_bloc.dart';
import 'package:tabibak_for_clinic/core/di/dependecy_injection.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_reports_refresh_notifier.dart';

part 'appointment_details_event.dart';
part 'appointment_details_state.dart';

class AppointmentDetailsBloc
    extends Bloc<AppointmentDetailsEvent, AppointmentDetailsState> {
  final GetAppointmentDetailsUseCase getAppointmentDetailsUseCase;
  final UpdateAppointmentStatusUseCase updateAppointmentStatusUseCase;
  final SetAppointmentFollowUpUseCase setFollowUpUseCase;
  final AppointmentBloc appointmentBloc;
  final AllAppointmentsBloc allAppointmentsBloc;
  AppointmentDetailsBloc(
      this.getAppointmentDetailsUseCase,
      this.updateAppointmentStatusUseCase,
      this.appointmentBloc,
      this.allAppointmentsBloc,
      this.setFollowUpUseCase)
      : super(AppointmentDetailsInitial()) {
    on<GetAppointmentDetailsEvent>((event, emit) async {
      emit(GetAppointmentDetailsLoading());

      final result =
          await getAppointmentDetailsUseCase.call(event.appointmentId);

      result.fold(
        (error) => emit(
            GetAppointmentDetailsFailure(error.message ?? 'Unknown error')),
        (appointmentEntity) => emit(
          GetAppointmentDetailsSuccess(
            appointmentEntity: appointmentEntity!,
          ),
        ),
      );
    });

    on<UpdateAppointmentEvent>((event, emit) async {
      if (event.actionType == "complete") {
        final appointmentDay = DateTime(event.appointmentDate.year,
            event.appointmentDate.month, event.appointmentDate.day);
        final today = DateTime.now();
        if (appointmentDay.isAfter(DateTime(today.year, today.month, today.day))) {
          emit(AppointmentActionFailure('Cannot complete an appointment before its scheduled day.'));
          return;
        }
      }
      emit(AppointmentActionLoading(actionType: event.actionType));
      final result = await updateAppointmentStatusUseCase.call(
          appointmentId: event.appointmentId,
          statusIndex: event.actionType == "cancel" ? 4 : 3);
      result.fold(
          (error) =>
              emit(AppointmentActionFailure(error.message ?? 'Unknown error')),
          (_) {
        getit<ClinicReportsRefreshNotifier>().notifyChanged();
        appointmentBloc.add(const GetAppointmentEvent());
        allAppointmentsBloc.add(RefreshAllAppointmentsEvent());
        emit(AppointmentActionSuccess());
      });
    });
    on<SetFollowUpEvent>((event, emit) async {
      emit(const AppointmentActionLoading(actionType: "followUp"));
      final result = await setFollowUpUseCase.call(
        followUpDate: event.date,
        appointmentId: event.appointmentId,
      );
      result.fold(
          (error) =>
              emit(AppointmentActionFailure(error.message ?? 'Unknown error')),
          (_) {
        getit<ClinicReportsRefreshNotifier>().notifyChanged();
        appointmentBloc.add(const GetAppointmentEvent());
        allAppointmentsBloc.add(RefreshAllAppointmentsEvent());
        emit(AppointmentActionSuccess());
      });
    });
  }
}
