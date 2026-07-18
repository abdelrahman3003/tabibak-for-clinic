import 'package:tabibak_for_clinic/feature/clinic/data/models/city_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_address_entity.dart';

class ClinicAddressModel extends ClinicAddressEntity {
  const ClinicAddressModel({
    super.id,
    super.clinicId,
    super.city,
    super.clinicAddress,
    super.street,
    super.floor,
    super.department,
  });

  factory ClinicAddressModel.fromJson(Map<String, dynamic> json) {
    return ClinicAddressModel(
      id: json["id"],
      clinicId: json["clinic_id"],
      city: json["city"] != null
          ? CityModel.fromJson(json["city"] as Map<String, dynamic>)
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
      "city_id": city?.id,
      "street": street,
      "floor": floor,
      "department": department,
    };
  }

  factory ClinicAddressModel.fromEntity(ClinicAddressEntity entity) {
    return ClinicAddressModel(
      id: entity.id,
      clinicId: entity.clinicId,
      city: entity.city,
      clinicAddress: entity.clinicAddress,
      street: entity.street,
      floor: entity.floor,
      department: entity.department,
    );
  }
}
