import 'package:tabibak_for_clinic/feature/clinic/data/models/clinic_address_model.dart';
import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';

class ClinicInfoModel extends ClinicInfoEntity {
  ClinicInfoModel(
      {super.id,
      required super.clinicName,
      required super.phoneNumber,
      required super.consultationFee,
      super.followUpFee,
      required super.address,
      required super.isBooking,
      required super.isAvailable});

  factory ClinicInfoModel.fromJson(Map<String, dynamic> json) {
    ClinicAddressModel? addressModel;
    final rawAddress = json['clinic_address'];
    if (rawAddress is List && rawAddress.isNotEmpty) {
      addressModel = ClinicAddressModel.fromJson(
          rawAddress.first as Map<String, dynamic>);
    } else if (rawAddress is Map<String, dynamic>) {
      addressModel = ClinicAddressModel.fromJson(rawAddress);
    }

    return ClinicInfoModel(
      id: json["id"],
      clinicName: json["clinic_name"],
      phoneNumber: json["phone_number"],
      address: addressModel,
      consultationFee: json["consultation_fee"],
      followUpFee: json["follow_up_fee"],
      isBooking: json["is_booking"],
      isAvailable: json["is_available"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "clinic_name": clinicName,
      "phone_number": phoneNumber,
      "consultation_fee": consultationFee,
      "follow_up_fee": followUpFee,
      "is_booking": isBooking,
      "is_available": isBooking,
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
        followUpFee: followUpFee,
        isBooking: isBooking,
        isAvailable: isAvailable);
  }
}
