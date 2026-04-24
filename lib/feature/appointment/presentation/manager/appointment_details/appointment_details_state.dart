part of 'appointment_details_bloc.dart';

sealed class AppointmentDetailsState extends Equatable {
  const AppointmentDetailsState();
  @override
  List<Object?> get props => [];
}

class AppointmentDetailsInitial extends AppointmentDetailsState {}

class GetAppointmentDetailsLoading extends AppointmentDetailsState {}

class GetAppointmentDetailsSuccess extends AppointmentDetailsState {
  final AppointmentEntity appointmentEntity;
  const GetAppointmentDetailsSuccess({required this.appointmentEntity});
  @override
  List<Object?> get props => [];
}

class GetAppointmentDetailsFailure extends AppointmentDetailsState {
  final String message;
  const GetAppointmentDetailsFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class AppointmentActionLoading extends AppointmentDetailsState {
  final String actionType;

  const AppointmentActionLoading(
      {required this.actionType}); // "cancel" or "followUp"
}

class AppointmentActionSuccess extends AppointmentDetailsState {}

class AppointmentActionFailure extends AppointmentDetailsState {
  final String message;
  const AppointmentActionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
