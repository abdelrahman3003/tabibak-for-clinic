import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_appointment_details_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/update_appointment_status_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/presentation/manager/appoinment/appointment_bloc.dart';

part 'appointment_details_event.dart';
part 'appointment_details_state.dart';

class AppointmentDetailsBloc
    extends Bloc<AppointmentDetailsEvent, AppointmentDetailsState> {
  final GetAppointmentDetailsUseCase getAppointmentDetailsUseCase;
  final UpdateAppointmentStatusUseCase updateAppointmentStatusUseCase;
  final AppointmentBloc appointmentBloc;
  AppointmentDetailsBloc(this.getAppointmentDetailsUseCase,
      this.updateAppointmentStatusUseCase, this.appointmentBloc)
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

    on<CancelAppointmentEvent>((event, emit) async {
      emit(CancelAppointmentLoading());
      final result = await updateAppointmentStatusUseCase.call(
        appointmentId: event.appointmentId,
        statusIndex: 3,
      );
      result.fold(
          (error) =>
              emit(CancelAppointmentFailure(error.message ?? 'Unknown error')),
          (_) {
        appointmentBloc.add(const GetAppointmentEvent());
        emit(CancelAppointmentSuccess());
      });
    });
  }
}
