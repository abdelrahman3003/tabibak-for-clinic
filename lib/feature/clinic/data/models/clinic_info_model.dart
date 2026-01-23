import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_address_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';

class ClinicInfoModel extends ClinicInfoEntity {
  ClinicInfoModel({
    super.id,
    required super.clinicName,
    required super.phoneNumber,
    required super.consultationFee,
    required super.address,
    required super.isBooking,
  });

  factory ClinicInfoModel.fromJson(Map<String, dynamic> json) {
    return ClinicInfoModel(
      id: json["id"],
      clinicName: json["clinic_name"],
      phoneNumber: json["phone_number"],
      address: json['clinic_address'] != null
          ? ClinicAddressModel.fromJson(
              json['clinic_address'] as Map<String, dynamic>,
            )
          : null,
      consultationFee: json["consultation_fee"],
      isBooking: json["isBooking"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "clinic_name": clinicName,
      "phone_number": phoneNumber,
      "consultation_fee": consultationFee,
      "isBooking": isBooking,
    };
  }
}

extension ClinicInfoEntityMapper on ClinicInfoEntity {
  ClinicInfoModel toModel() {
    return ClinicInfoModel(
      id: id,
      clinicName: clinicName,
      phoneNumber: phoneNumber,
      address: address,
      consultationFee: consultationFee,
      isBooking: isBooking,
    );
  }
}
