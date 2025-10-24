import 'package:equatable/equatable.dart';

class UniversityEntity extends Equatable {
  final String universityName;
  final int graduationYear;

  const UniversityEntity(
      {required this.universityName, required this.graduationYear});

  @override
  List<Object?> get props => [universityName, graduationYear];
}
