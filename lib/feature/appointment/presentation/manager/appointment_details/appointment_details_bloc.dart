import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_appointment_details_use_case.dart';

part 'appointment_details_event.dart';
part 'appointment_details_state.dart';

class AppointmentDetailsBloc
    extends Bloc<AppointmentDetailsEvent, AppointmentDetailsState> {
  final GetAppointmentDetailsUseCase getAppointmentDetailsUseCase;

  AppointmentDetailsBloc(this.getAppointmentDetailsUseCase)
      : super(AppointmentDetailsInitial()) {
    on<GetAppointmentDetailsEvent>((event, emit) async {
      emit(GetAppointmentDetailsLoading());

      final result =
          await getAppointmentDetailsUseCase.call(event.appointmentId);

      result.fold(
        (error) => emit(
            GetAppointmentDetailsFailure(error.message ?? 'Unknown error')),
        (appointmentEntity) => emit(GetAppointmentDetailsSuccess(
            appointmentEntity: appointmentEntity!)),
      );
    });
  }
}
