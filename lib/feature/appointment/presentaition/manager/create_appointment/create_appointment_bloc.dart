import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/entities/appointment_entity.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/add_appointment_use_case.dart';
import 'package:tabibak_for_clinic/feature/appointment/domain/usecase/get_appointment_shift_use_case.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_shift_entity.dart';

part 'create_appointment_event.dart';
part 'create_appointment_state.dart';

class CreateAppointmentBloc
    extends Bloc<CreateAppointmentEvent, CreateAppointmentState> {
  final GetAppointmentShiftUseCase getAppointmentShiftUseCase;
  final AddAppointmentUseCase addAppointmentUseCase;
  CreateAppointmentBloc(
      this.getAppointmentShiftUseCase, this.addAppointmentUseCase)
      : super(CreateAppointmentInitial()) {
    on<GetAppointmentShiftEvent>((event, emit) async {
      emit(GetAppointmentShiftLoading());
      final result = await getAppointmentShiftUseCase.call(event.dayEn);
      result.fold(
        (error) {
          emit(GetAppointmentShiftFailed(errorMessage: error.message!));
        },
        (shift) {
          emit(GetAppointmentShiftSuccess(clinicShiftEntity: shift));
        },
      );
    });
    on<AddAppointmentEvent>((event, emit) async {
      emit(AddAppointmentLoading());
      final result = await addAppointmentUseCase.call(event.appointment);
      result.fold(
        (error) {
          emit(AddAppointmentFailed(errorMessage: error.message!));
        },
        (shift) {
          emit(AddAppointmentSuccess());
        },
      );
    });
  }
}
