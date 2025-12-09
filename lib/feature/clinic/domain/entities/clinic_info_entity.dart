class ClinicInfoEntity {
  final String? clinicName;
  final String? phoneNumber;
  final int? consultationFee;
  final bool? isBooking;

  const ClinicInfoEntity({
    required this.clinicName,
    required this.phoneNumber,
    required this.consultationFee,
    required this.isBooking,
  });
}
