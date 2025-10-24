import 'package:tabibak_for_clinic/feature/auth/domain/entities/clinic_entity.dart';

class ClinicModel extends ClinicEntity {
  final int doctorId;

  const ClinicModel({
    required super.clinicName,
    required super.address,
    required super.isBooking,
    required super.consultationFee,
    required super.phoneNumber,
    required this.doctorId,
  });

  Map<String, dynamic> toJson() {
    return {
      "doctor_id": doctorId,
      "clinic_name": clinicName,
      "address": address,
      "phone_number": phoneNumber,
      "consultation_fee": consultationFee,
      "isBooking": isBooking,
    };
  }
}
