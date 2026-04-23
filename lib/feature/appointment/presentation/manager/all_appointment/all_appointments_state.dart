part of 'all_appointments_bloc.dart';

abstract class AllAppointmentsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AllAppointmentsInitial extends AllAppointmentsState {}

class ToggleIndexState extends AllAppointmentsState {
  final int index;
  ToggleIndexState(this.index);
  @override
  List<Object?> get props => [index];
}

// ✅ Per-tab states carry their type so UI knows which tab to update
class AllAppointmentsLoading extends AllAppointmentsState {
  final AppointmentType type;
  AllAppointmentsLoading(this.type);
  @override
  List<Object?> get props => [type];
}

class AllAppointmentsSuccess extends AllAppointmentsState {
  final List<AppointmentEntity> appointments;
  final AppointmentType type;
  AllAppointmentsSuccess(this.appointments, this.type);
  @override
  List<Object?> get props => [appointments, type];
}

class AllAppointmentsFailure extends AllAppointmentsState {
  final String message;
  final AppointmentType type;
  AllAppointmentsFailure(this.message, this.type);
  @override
  List<Object?> get props => [message, type];
}

class UpdateAppointmentStatusLoading extends AllAppointmentsState {
  final String? loadingKey;

  UpdateAppointmentStatusLoading({required this.loadingKey});
}

class UpdateAppointmentStatusSuccess extends AllAppointmentsState {}

class UpdateAppointmentStatusFailure extends AllAppointmentsState {
  final String message;
  UpdateAppointmentStatusFailure(this.message);
  @override
  List<Object?> get props => [message];
}
