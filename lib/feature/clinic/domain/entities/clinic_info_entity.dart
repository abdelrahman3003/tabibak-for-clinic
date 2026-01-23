import 'package:tabibak_for_clinic/feature/clinic/domain/entities/clinic_address_entity.dart';

class ClinicInfoEntity {
  final int? id;
  final String? clinicName;
  final String? phoneNumber;
  final ClinicAddressEntity? address;
  final int? consultationFee;
  final bool? isBooking;

  const ClinicInfoEntity({
    this.id,
    required this.clinicName,
    required this.phoneNumber,
    this.address,
    required this.consultationFee,
    required this.isBooking,
  });
}
