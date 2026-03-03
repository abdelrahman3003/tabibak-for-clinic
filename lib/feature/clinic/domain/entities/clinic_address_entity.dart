import 'package:equatable/equatable.dart';

class ClinicAddressEntity extends Equatable {
  final int? id;
  final int? clinicId;
  final String? clinicAddress;
  final String? city;
  final String? street;
  final String? floor;
  final String? department;

  const ClinicAddressEntity({
    this.id,
    this.clinicAddress,
    this.clinicId,
    this.city,
    this.street,
    this.floor,
    this.department,
  });

  @override
  List<Object?> get props =>
      [id, clinicAddress, clinicId, city, street, floor, department];
}
