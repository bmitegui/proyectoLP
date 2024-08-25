import 'package:equatable/equatable.dart';

enum RouteType { gastronomia, ciudad, aventura, cultura }

class RouteEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime routeDate;
  final String startTime;
  final String endTime;
  final List<RouteType> routeTypes;

  const RouteEntity(
      {required this.id,
      required this.name,
      required this.description,
      required this.routeDate,
      required this.startTime,
      required this.endTime,
      required this.routeTypes});

  @override
  List<Object?> get props => [id];
}
