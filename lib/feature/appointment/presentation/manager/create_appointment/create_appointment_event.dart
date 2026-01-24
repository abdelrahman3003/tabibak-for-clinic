part of 'create_appointment_bloc.dart';

sealed class CreateAppointmentEvent extends Equatable {
  const CreateAppointmentEvent();

  @override
  List<Object> get props => [];
}

class GetAppointmentShiftEvent extends CreateAppointmentEvent {
  final String dayEn;

  const GetAppointmentShiftEvent({required this.dayEn});

  @override
  List<Object> get props => [dayEn];
}

class AddAppointmentEvent extends CreateAppointmentEvent {
  final AppointmentEntity appointment;

  const AddAppointmentEvent({required this.appointment});
  @override
  List<Object> get props => [appointment];
}
