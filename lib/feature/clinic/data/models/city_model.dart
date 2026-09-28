import 'package:tabibak_for_clinic/feature/clinic/domain/entities/city_entity.dart';

class CityModel extends CityEntity {
  const CityModel({
    super.id,
    super.nameAr,
    super.nameEn,
    super.governorateId,
    super.parentId,
    super.type,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      governorateId: json['governorate_id'],
      parentId: json['parent_id'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'governorate_id': governorateId,
      'parent_id': parentId,
      'type': type,
    };
  }
}

extension CityMapper on CityModel {
  CityEntity toEntity() {
    return CityEntity(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      governorateId: governorateId,
      parentId: parentId,
      type: type,
    );
  }
}
