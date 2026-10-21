import 'package:equatable/equatable.dart';

class OfferEntity extends Equatable {
  final int? id;
  final String? titleEn;
  final String? titleAr;
  final String? detailsEn;
  final String? detailsAr;
  final num? discount;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? expiryDate;
  final String? doctorId;
  final int? clinicId;
  final bool isActive;
  final DateTime? createdAt;

  const OfferEntity({
    this.id,
    this.titleEn,
    this.titleAr,
    this.detailsEn,
    this.detailsAr,
    this.discount,
    this.startDate,
    this.endDate,
    this.expiryDate,
    this.doctorId,
    this.clinicId,
    this.isActive = true,
    this.createdAt,
  });

  /// Checks whether the offer has expired based on expiryDate or endDate.
  bool get isExpired {
    final expiry = expiryDate ?? endDate;
    if (expiry == null) return false;
    return expiry.isBefore(DateTime.now());
  }

  /// An offer is considered valid if it is active and not expired.
  bool get isValid => isActive && !isExpired;

  OfferEntity copyWith({
    int? id,
    String? titleEn,
    String? titleAr,
    String? detailsEn,
    String? detailsAr,
    num? discount,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? expiryDate,
    String? doctorId,
    int? clinicId,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return OfferEntity(
      id: id ?? this.id,
      titleEn: titleEn ?? this.titleEn,
      titleAr: titleAr ?? this.titleAr,
      detailsEn: detailsEn ?? this.detailsEn,
      detailsAr: detailsAr ?? this.detailsAr,
      discount: discount ?? this.discount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      expiryDate: expiryDate ?? this.expiryDate,
      doctorId: doctorId ?? this.doctorId,
      clinicId: clinicId ?? this.clinicId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        titleEn,
        titleAr,
        detailsEn,
        detailsAr,
        discount,
        startDate,
        endDate,
        expiryDate,
        doctorId,
        clinicId,
        isActive,
        createdAt,
      ];
}
