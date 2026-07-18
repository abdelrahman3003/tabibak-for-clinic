import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final int? id;
  final String? nameAr;
  final String? nameEn;

  const CityEntity({
    this.id,
    this.nameAr,
    this.nameEn,
  });

  @override
  List<Object?> get props => [
        id,
        nameAr,
        nameEn,
      ];
}
