import 'package:tabibak_for_clinic/feature/clinic/domain/entities/governorate_entity.dart';

class GovernorateModel extends GovernorateEntity {
  const GovernorateModel({
    super.id,
    super.nameAr,
    super.nameEn,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
    };
  }
}

extension GovernorateMapper on GovernorateModel {
  GovernorateEntity toEntity() {
    return GovernorateEntity(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
    );
  }
}
