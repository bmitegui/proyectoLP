import 'package:path_finder/features/route/domain/entities/entities.dart';

class StopModel extends StopEntity {
  const StopModel(
      {required super.id,
      required super.name,
      required super.startTimeHour,
      required super.startTimeMinute,
      required super.endTimeHour,
      required super.endTimeMinute,
      required super.latitude,
      required super.longitude});

  factory StopModel.fromJson(Map<String, dynamic> json) {
    return StopModel(
        id: 'id',
        name: json['name'],
        startTimeHour: json['startTime']['hour'],
        startTimeMinute: json['startTime']['minute'],
        endTimeHour: json['endTime']['hour'],
        endTimeMinute: json['endTime']['minute'],
        latitude: json['ubication']['latitude'],
        longitude: json['ubication']['longitude']);
  }
}
