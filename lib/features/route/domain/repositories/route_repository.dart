import 'package:dartz/dartz.dart';
import 'package:path_finder/core/error/error.dart';
import 'package:path_finder/features/route/data/models/models.dart';

abstract class RouteRepository {
  Future<Either<Failure, List<RouteModel>>> getRoutes();
}
