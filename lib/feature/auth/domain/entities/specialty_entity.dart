import 'package:equatable/equatable.dart';

class SpecialtyEntity extends Equatable {
  final int id;
  final String nameAr;
  final String nameEn;
  final String icon;

  const SpecialtyEntity(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.icon});

  @override
  List<Object?> get props => [id, nameAr, nameEn, icon];
}
