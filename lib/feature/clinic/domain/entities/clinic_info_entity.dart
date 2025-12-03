class ClinicInfoEntity {
  final String clinicName;
  final String address;
  final String phoneNumber;
  final int consultationFee;
  final bool isBooking;
  final int doctorId;

  const ClinicInfoEntity({
    required this.clinicName,
    required this.address,
    required this.phoneNumber,
    required this.consultationFee,
    required this.isBooking,
    required this.doctorId,
  });
}
