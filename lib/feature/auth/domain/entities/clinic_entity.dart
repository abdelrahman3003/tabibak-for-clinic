import 'package:equatable/equatable.dart';

class ClinicEntity extends Equatable {
  final String clinicName;
  final String address;
  final String phoneNumber;
  final bool isBooking;
  final double consultationFee;

  const ClinicEntity({
    required this.clinicName,
    required this.address,
    required this.isBooking,
    required this.consultationFee,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [clinicName, address, isBooking, consultationFee];
}
