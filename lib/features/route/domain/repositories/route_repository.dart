import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path_finder/core/error/error.dart';
import 'package:path_finder/features/route/data/models/models.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';

abstract class RouteRepository {
  Future<Either<Failure, List<RouteModel>>> getRoutes();
  Future<Either<Failure, RouteModel>> createRoute(
      {required RouteEntity route, required File file});
}
