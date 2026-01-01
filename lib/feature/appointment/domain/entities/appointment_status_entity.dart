import 'package:equatable/equatable.dart';

class AppointmentStatusEntity extends Equatable {
  final int? id;
  final String? status;

  const AppointmentStatusEntity({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status];
}
