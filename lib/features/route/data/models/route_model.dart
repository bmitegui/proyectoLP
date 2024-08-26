import 'package:path_finder/features/route/data/models/models.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';

class RouteModel extends RouteEntity {
  const RouteModel(
      {required super.id,
      required super.name,
      required super.description,
      required super.routeDate,
      required super.startTime,
      required super.endTime,
      required super.routeTypes,
      required super.stops});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    List<RouteType> routeTypes = [];
    List<StopEntity> stops = [];

    for (String routeType in json['routeType']) {
      if (routeType == 'Gastronomía') {
        routeTypes.add(RouteType.gastronomia);
      } else if (routeType == 'Ciudad') {
        routeTypes.add(RouteType.ciudad);
      } else if (routeType == 'Aventura') {
        routeTypes.add(RouteType.aventura);
      } else if (routeType == 'Cultura') {
        routeTypes.add(RouteType.cultura);
      }
    }

    stops = (json['stops'] as List)
        .map((stopJson) => StopModel.fromJson(stopJson))
        .toList();

    return RouteModel(
        id: 'id',
        name: json['name'],
        description: json['description'],
        routeDate: DateTime.parse(json['routeDate']),
        startTime: json['startTime'],
        endTime: json['endTime'],
        routeTypes: routeTypes,
        stops: stops);
  }
}
