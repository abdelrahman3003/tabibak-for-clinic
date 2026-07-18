import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';

class ClinicAddressEntity extends Equatable {
  final int? id;
  final int? clinicId;
  final CityEntity? city;
  final String? clinicAddress;
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
