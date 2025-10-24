import 'package:equatable/equatable.dart';
import 'package:tabibak_for_clinic/feature/auth/domain/entities/time_entity.dart';

class ShiftEntity extends Equatable {
  final TimeEntity morning;
  final TimeEntity evening;

  const ShiftEntity({required this.morning, required this.evening});

  @override
  List<Object?> get props => [morning, evening];
}
