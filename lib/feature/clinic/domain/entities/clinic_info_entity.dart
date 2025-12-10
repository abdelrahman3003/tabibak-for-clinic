class ClinicInfoEntity {
  final int? id;
  final String? clinicName;
  final String? phoneNumber;
  final String? address;
  final int? consultationFee;
  final bool? isBooking;

  const ClinicInfoEntity({
    this.id,
    required this.clinicName,
    required this.phoneNumber,
    required this.address,
    required this.consultationFee,
    required this.isBooking,
  });
}
