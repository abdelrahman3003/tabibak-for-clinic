import 'package:tabibak_for_clinic/feature/auth/domain/entities/specialty_entity.dart';

class SpecialtyModel extends SpecialtyEntity {
  const SpecialtyModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.icon,
  });
  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      icon: json['icon'] as String,
    );
  }
}
