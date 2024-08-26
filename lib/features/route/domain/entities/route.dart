import 'package:equatable/equatable.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';

enum RouteType { gastronomia, ciudad, aventura, cultura }

class RouteEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime routeDate;
  final String startTime;
  final String endTime;
  final List<RouteType> routeTypes;
  final List<StopEntity> stops;

  const RouteEntity(
      {required this.id,
      required this.name,
      required this.description,
      required this.routeDate,
      required this.startTime,
      required this.endTime,
      required this.routeTypes,
      required this.stops});

  @override
  List<Object?> get props => [id];
}
