import 'package:equatable/equatable.dart';

class AppointmentStatusEntity extends Equatable {
  final int? id;
  final String? statusEn;
  final String? statusAr;

  const AppointmentStatusEntity(
      {required this.id, required this.statusEn, required this.statusAr});

  @override
  List<Object?> get props => [id, statusAr, statusEn];
}
