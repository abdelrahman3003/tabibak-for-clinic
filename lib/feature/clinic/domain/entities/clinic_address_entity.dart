import 'package:equatable/equatable.dart';

class ClinicAddressEntity extends Equatable {
  final int? id;
  final int? clinicId;

  final String? clinicAddress;

  const ClinicAddressEntity({
    this.id,
    this.clinicAddress,
    this.clinicId,
  });

  @override
  List<Object?> get props => [id, clinicAddress, clinicId];
}
