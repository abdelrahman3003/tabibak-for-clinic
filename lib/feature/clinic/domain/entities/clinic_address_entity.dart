import 'package:equatable/equatable.dart';

class ClinicAddressEntity extends Equatable {
  final int? id;
  final String? clinicAddress;

  const ClinicAddressEntity({required this.id, required this.clinicAddress});

  @override
  List<Object?> get props => [id, clinicAddress];
}
