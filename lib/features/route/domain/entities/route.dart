import 'package:equatable/equatable.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';

enum RouteType { naturaleza, religion, gastronomia, ciudad, aventura, cultura }

class RouteEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String urlImage;
  final int peopleNumber;
  final int guidesNumber;
  final double alertRange;
  final bool showInfo;
  final String alertSound;
  final bool isPublic;
  final DateTime initialDate;
  final List<RouteType> routeTypes;
  final List<StopEntity> stops;
  final double latitude;
  final double longitude;

  const RouteEntity(
      {required this.id,
      required this.name,
      required this.description,
      required this.urlImage,
      required this.peopleNumber,
      required this.guidesNumber,
      required this.alertRange,
      required this.showInfo,
      required this.alertSound,
      required this.isPublic,
      required this.initialDate,
      required this.routeTypes,
      required this.stops,
      required this.latitude,
      required this.longitude});

  RouteEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? urlImage,
    int? peopleNumber,
    int? guidesNumber,
    double? alertRange,
    bool? showInfo,
    String? alertSound,
    bool? isPublic,
    DateTime? initialDate,
    List<RouteType>? routeTypes,
    List<StopEntity>? stops,
    double? latitude,
    double? longitude,
  }) {
    return RouteEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        urlImage: urlImage ?? this.urlImage,
        peopleNumber: peopleNumber ?? this.peopleNumber,
        guidesNumber: guidesNumber ?? this.guidesNumber,
        alertRange: alertRange ?? this.alertRange,
        showInfo: showInfo ?? this.showInfo,
        alertSound: alertSound ?? this.alertSound,
        isPublic: isPublic ?? this.isPublic,
        initialDate: initialDate ?? this.initialDate,
        routeTypes: routeTypes ?? this.routeTypes,
        stops: stops ?? this.stops,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'urlImage': urlImage,
      'peopleNumber': peopleNumber,
      'guidesNumber': guidesNumber,
      'alertRange': alertRange,
      'showInfo': showInfo,
      'alertSound': alertSound,
      'isPublic': isPublic,
      'initialDate': initialDate.toIso8601String(),
      'routeTypes':
          routeTypes.map((type) => type.toString().split('.').last).toList(),
      'stops': stops.map((stop) => stop.toJson()).toList(),
      'latitude': latitude,
      'longitude': longitude
    };
  }

  @override
  List<Object?> get props => [id];
}
