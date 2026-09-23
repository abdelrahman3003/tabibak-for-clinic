part of 'all_appointments_bloc.dart';

sealed class AllAppointmentsEvent extends Equatable {
  const AllAppointmentsEvent();

  @override
  List<Object> get props => [];
}

class GetUpcomingAppointmentsEvent extends AllAppointmentsEvent {}

class GetFinishedAppointmentsEvent extends AllAppointmentsEvent {}

class GetCanceledAppointmentsEvent extends AllAppointmentsEvent {}

class RefreshAllAppointmentsEvent extends AllAppointmentsEvent {}

class SearchAppointmentsEvent extends AllAppointmentsEvent {
  final String name;
  const SearchAppointmentsEvent(this.name);

  @override
  List<Object> get props => [name];
}

class UpdateAppointmentStatusEvent extends AllAppointmentsEvent {
  final int statusIndex;
  final int appointmentId;

  const UpdateAppointmentStatusEvent({
    required this.statusIndex,
    required this.appointmentId,
  });

  @override
  List<Object> get props => [statusIndex, appointmentId];
}

class ChangeTabEvent extends AllAppointmentsEvent {
  final int index;
  const ChangeTabEvent(this.index);
}
