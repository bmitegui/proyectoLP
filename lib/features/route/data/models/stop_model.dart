import 'package:path_finder/features/route/data/models/route_model.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';

class StopModel extends StopEntity {
  const StopModel(
      {required super.name,
      required super.initialDate,
      required super.endDate,
      required super.latitude,
      required super.longitude});

  factory StopModel.fromJson(Map<String, dynamic> json) {
    return StopModel(
        name: json['name'],
        initialDate: RouteModel.timestampToDateTime(json['initialDate']),
        endDate: RouteModel.timestampToDateTime(json['endDate']),
        latitude: json['latitude'],
        longitude: json['longitude']);
  }
}
