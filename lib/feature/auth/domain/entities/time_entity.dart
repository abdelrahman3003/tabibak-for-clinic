import 'package:equatable/equatable.dart';

class TimeEntity extends Equatable {
  final String start;
  final String end;

  const TimeEntity({required this.start, required this.end});

  @override
  List<Object?> get props => [start, end];
}
