import 'package:equatable/equatable.dart';

class StopEntity extends Equatable {
  final String id;
  final String name;
  final int startTimeHour;
  final int startTimeMinute;

  final int endTimeHour;
  final int endTimeMinute;
  final double latitude;
  final double longitude;

  const StopEntity(
      {required this.id,
      required this.name,
      required this.startTimeHour,
      required this.startTimeMinute,
      required this.endTimeHour,
      required this.endTimeMinute,
      required this.latitude,
      required this.longitude});

  @override
  List<Object?> get props => [id];
}
