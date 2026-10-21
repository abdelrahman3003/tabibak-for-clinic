import 'package:tabibak_for_clinic/feature/clinic/domain/entities/offer_entity.dart';

class OfferModel extends OfferEntity {
  const OfferModel({
    super.id,
    super.titleEn,
    super.titleAr,
    super.detailsEn,
    super.detailsAr,
    super.discount,
    super.startDate,
    super.endDate,
    super.expiryDate,
    super.doctorId,
    super.clinicId,
    super.isActive = true,
    super.createdAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as int?,
      titleEn: json['title_en'] as String?,
      titleAr: json['title_ar'] as String?,
      detailsEn: json['details_en'] as String?,
      detailsAr: json['details_ar'] as String?,
      discount: json['discount'] as num?,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'] as String)
          : null,
      expiryDate: json['expiry_date'] != null
          ? DateTime.tryParse(json['expiry_date'] as String)
          : null,
      doctorId: json['doctor_id'] as String?,
      clinicId: json['clinic_id'] as int?,
      isActive: (json['is_active'] as bool?) ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title_en': titleEn,
      'title_ar': titleAr,
      'details_en': detailsEn,
      'details_ar': detailsAr,
      'discount': discount,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'expiry_date': (expiryDate ?? endDate)?.toIso8601String(),
      'clinic_id': clinicId,
      'is_active': isActive,
    };
    if (id != null && id! > 0) {
      map['id'] = id;
    }
    if (doctorId != null && doctorId!.isNotEmpty) {
      map['doctor_id'] = doctorId;
    }
    return map;
  }

  factory OfferModel.fromEntity(OfferEntity entity) {
    return OfferModel(
      id: entity.id,
      titleEn: entity.titleEn,
      titleAr: entity.titleAr,
      detailsEn: entity.detailsEn,
      detailsAr: entity.detailsAr,
      discount: entity.discount,
      startDate: entity.startDate,
      endDate: entity.endDate,
      expiryDate: entity.expiryDate,
      doctorId: entity.doctorId,
      clinicId: entity.clinicId,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }

  OfferEntity toEntity() {
    return OfferEntity(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      detailsEn: detailsEn,
      detailsAr: detailsAr,
      discount: discount,
      startDate: startDate,
      endDate: endDate,
      expiryDate: expiryDate,
      doctorId: doctorId,
      clinicId: clinicId,
      isActive: isActive,
      createdAt: createdAt,
    );
  }
}
