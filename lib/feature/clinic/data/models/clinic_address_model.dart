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

  static Map<String, dynamic>? _extractMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is List &&
        value.isNotEmpty &&
        value.first is Map<String, dynamic>) {
      return value.first as Map<String, dynamic>;
    }
    return null;
  }

  factory ClinicAddressModel.fromJson(Map<String, dynamic> json) {
    final govMap = _extractMap(json["governorate"] ?? json["governorates"]);
    final markazMap = _extractMap(json["markaz"]);
    final villageMap = _extractMap(json["village"] ?? json["villages"]);

    return ClinicAddressModel(
      id: json["id"],
      clinicId: json["clinic_id"],
      governorate: govMap != null
          ? GovernorateModel.fromJson(govMap)
          : (json["governorate_id"] != null
              ? GovernorateModel(id: json["governorate_id"] as int?)
              : null),
      markaz: markazMap != null
          ? CityModel.fromJson(markazMap)
          : (json["markaz_id"] != null
              ? CityModel(id: json["markaz_id"] as int?)
              : null),
      village: villageMap != null
          ? CityModel.fromJson(villageMap)
          : (json["village_id"] != null
              ? CityModel(id: json["village_id"] as int?)
              : null),
      clinicAddress: json["street"] ?? json["clinic_address"],
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
