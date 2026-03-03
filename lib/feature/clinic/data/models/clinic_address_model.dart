import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_address_entity.dart';

class ClinicAddressModel extends ClinicAddressEntity {
  const ClinicAddressModel({
    super.id,
    super.clinicId,
    super.clinicAddress,
    super.city,
    super.street,
    super.floor,
    super.department,
  });
  factory ClinicAddressModel.fromJson(Map<String, dynamic> json) {
    return ClinicAddressModel(
      id: json["id"],
      clinicAddress: json['address'],
      clinicId: json['clinic_id'],
      city: json['city'],
      street: json['street'],
      floor: json['floor'],
      department: json['department'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "address": clinicAddress,
      'clinic_id': clinicId,
      'city': city,
      'street': street,
      'floor': floor,
      'department': department,
    };
  }

  factory ClinicAddressModel.fromEntity(ClinicAddressEntity entity) {
    return ClinicAddressModel(
      id: entity.id,
      clinicId: entity.clinicId,
      clinicAddress: entity.clinicAddress,
      city: entity.city,
      street: entity.street,
      floor: entity.floor,
      department: entity.department,
    );
  }
}
