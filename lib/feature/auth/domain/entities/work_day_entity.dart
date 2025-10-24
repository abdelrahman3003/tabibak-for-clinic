import 'package:equatable/equatable.dart';

class WorkDayEntity extends Equatable {
  final int day;

  const WorkDayEntity({required this.day});

  @override
  List<Object?> get props => [day];
}
