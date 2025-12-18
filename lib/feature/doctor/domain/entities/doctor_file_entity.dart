import 'package:equatable/equatable.dart';

class DoctorFileEntity extends Equatable {
  final int id;
  final String fileUrl;

  const DoctorFileEntity({required this.id, required this.fileUrl});

  @override
  List<Object?> get props => [id, fileUrl];
}
