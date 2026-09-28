import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/governorate_entity.dart';

class ClinicAddressEntity extends Equatable {
  final int? id;
  final int? clinicId;
  final GovernorateEntity? governorate;
  final CityEntity? markaz;
  final CityEntity? village;
  final String? clinicAddress;
  final String? street;
  final String? floor;
  final String? department;

  const ClinicAddressEntity({
    this.id,
    this.clinicAddress,
    this.clinicId,
    this.governorate,
    this.markaz,
    this.village,
    this.street,
    this.floor,
    this.department,
  });

  @override
  List<Object?> get props =>
      [id, clinicAddress, clinicId, governorate, markaz, village, street, floor, department];
}
