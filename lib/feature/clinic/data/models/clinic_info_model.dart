import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';

class ClinicInfoModel extends ClinicInfoEntity {
  ClinicInfoModel({
    required super.clinicName,
    required super.phoneNumber,
    required super.consultationFee,
    required super.isBooking,
  });

  factory ClinicInfoModel.fromJson(Map<String, dynamic> json) {
    return ClinicInfoModel(
      clinicName: json["clinic_name"],
      phoneNumber: json["phone_number"],
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
