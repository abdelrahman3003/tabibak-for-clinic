class ClinicInfoModel {
  final String clinicName;
  final String address;
  final String phoneNumber;
  final int consultationFee;
  final bool isBooking;
  final int doctorId;

  ClinicInfoModel({
    required this.clinicName,
    required this.address,
    required this.phoneNumber,
    required this.consultationFee,
    required this.isBooking,
    required this.doctorId,
  });

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
}
