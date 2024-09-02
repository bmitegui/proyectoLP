import 'package:equatable/equatable.dart';

class StopEntity extends Equatable {
  final String name;
  final DateTime initialDate;
  final DateTime endDate;
  final double latitude;
  final double longitude;

  const StopEntity(
      {required this.name,
      required this.initialDate,
      required this.endDate,
      required this.latitude,
      required this.longitude});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'initialDate': initialDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude
    };
  }

  @override
  List<Object?> get props => [name, latitude, longitude, initialDate, endDate];
}
