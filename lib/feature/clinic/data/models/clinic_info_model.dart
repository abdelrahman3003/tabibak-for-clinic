import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_info_entity.dart';

class ClinicInfoModel extends ClinicInfoEntity {
  ClinicInfoModel({
    required super.clinicName,
    required super.address,
    required super.phoneNumber,
    required super.consultationFee,
    required super.isBooking,
    required super.doctorId,
  });

  factory ClinicInfoModel.fromJson(Map<String, dynamic> json) {
    return ClinicInfoModel(
      clinicName: json["clinic_name"],
      address: json["address"],
      phoneNumber: json["phone_number"],
      consultationFee: json["consultation_fee"],
      isBooking: json["isBooking"],
      doctorId: json["doctor_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "clinic_name": clinicName,
      "address": address,
      "phone_number": phoneNumber,
      "consultation_fee": consultationFee,
      "isBooking": isBooking,
      "doctor_id": doctorId,
    };
  }
}
