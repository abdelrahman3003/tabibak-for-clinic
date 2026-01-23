import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_address_entity.dart';

class ClinicAddressModel extends ClinicAddressEntity {
  const ClinicAddressModel({super.id, super.clinicAddress});
  factory ClinicAddressModel.fromJson(Map<String, dynamic> json) {
    return ClinicAddressModel(id: json["id"], clinicAddress: json['address']);
  }

  Map<String, dynamic> toJson() {
    return {
      "address": clinicAddress,
    };
  }
}
