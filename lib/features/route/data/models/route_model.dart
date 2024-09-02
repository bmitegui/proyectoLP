import 'package:path_finder/features/route/data/models/stop_model.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';

class RouteModel extends RouteEntity {
  const RouteModel(
      {required super.id,
      required super.name,
      required super.description,
      required super.peopleNumber,
      required super.guidesNumber,
      required super.alertRange,
      required super.showInfo,
      required super.alertSound,
      required super.isPublic,
      required super.initialDate,
      required super.routeTypes,
      required super.stops,
      required super.latitude,
      required super.longitude,
      required super.urlImage});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    List<RouteType> routeTypes = [];

    for (String routeType in json['routeTypes']) {
      if (routeType == 'gastronomia') {
        routeTypes.add(RouteType.gastronomia);
      } else if (routeType == 'ciudad') {
        routeTypes.add(RouteType.ciudad);
      } else if (routeType == 'aventura') {
        routeTypes.add(RouteType.aventura);
      } else if (routeType == 'cultura') {
        routeTypes.add(RouteType.cultura);
      } else if (routeType == 'naturaleza') {
        routeTypes.add(RouteType.naturaleza);
      } else if (routeType == 'religion') {
        routeTypes.add(RouteType.religion);
      }
    }
    return RouteModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        peopleNumber: json['peopleNumber'],
        guidesNumber: json['guidesNumber'],
        alertRange: json['alertRange'].toDouble(),
        showInfo: json['showInfo'],
        alertSound: json['alertSound'],
        isPublic: json['isPublic'],
        initialDate: timestampToDateTime(json['initialDate']),
        routeTypes: routeTypes,
        stops: List<StopEntity>.from(
            json['stops'].map((stop) => StopModel.fromJson(stop))),
        latitude: json['latitude'].toDouble(),
        longitude: json['longitude'].toDouble(),
        urlImage: json['urlImage']);
  }

  static DateTime timestampToDateTime(Map<String, dynamic> timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(
      timestamp['_seconds'] * 1000 + timestamp['_nanoseconds'] ~/ 1000000,
    );
  }
}
