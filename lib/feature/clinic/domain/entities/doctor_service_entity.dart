import 'package:equatable/equatable.dart';

class DoctorServiceEntity extends Equatable {
  final int? id;
  final String? doctorId;
  final int? clinicId;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DoctorServiceEntity({
    this.id,
    this.doctorId,
    this.clinicId,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  DoctorServiceEntity copyWith({
    int? id,
    String? doctorId,
    int? clinicId,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DoctorServiceEntity(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      clinicId: clinicId ?? this.clinicId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        doctorId,
        clinicId,
        name,
        createdAt,
        updatedAt,
      ];
}
