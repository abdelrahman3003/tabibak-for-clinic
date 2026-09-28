import 'package:tabibak_for_clinic/feature/clinic/data/models/city_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/data/models/governorate_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_address_entity.dart';

class ClinicAddressModel extends ClinicAddressEntity {
  const ClinicAddressModel({
    super.id,
    super.clinicId,
    super.governorate,
    super.markaz,
    super.village,
    super.clinicAddress,
    super.street,
    super.floor,
    super.department,
  });

  factory ClinicAddressModel.fromJson(Map<String, dynamic> json) {
    return ClinicAddressModel(
      id: json["id"],
      clinicId: json["clinic_id"],
      governorate: json["governorate"] != null
          ? GovernorateModel.fromJson(
              json["governorate"] as Map<String, dynamic>)
          : null,
      markaz: json["markaz"] != null
          ? CityModel.fromJson(json["markaz"] as Map<String, dynamic>)
          : null,
      village: json["village"] != null
          ? CityModel.fromJson(json["village"] as Map<String, dynamic>)
          : null,
      clinicAddress: json["street"],
      street: json["street"],
      floor: json["floor"],
      department: json["department"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "clinic_id": clinicId,
      "governorate_id": governorate?.id,
      "markaz_id": markaz?.id,
      "village_id": village?.id,
      "street": street,
      "floor": floor,
      "department": department,
    };
  }

  factory ClinicAddressModel.fromEntity(ClinicAddressEntity entity) {
    return ClinicAddressModel(
      id: entity.id,
      clinicId: entity.clinicId,
      governorate: entity.governorate,
      markaz: entity.markaz,
      village: entity.village,
      clinicAddress: entity.clinicAddress,
      street: entity.street,
      floor: entity.floor,
      department: entity.department,
    );
  }
}
