import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:path_finder/core/error/failures.dart';
import 'package:path_finder/core/usecases/usecase.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';
import 'package:path_finder/features/route/domain/repositories/route_repository.dart';

class CreateRoute implements UseCase<RouteEntity, CreateRouteParams> {
  final RouteRepository routeRepository;
  CreateRoute({required this.routeRepository});

  @override
  Future<Either<Failure, RouteEntity>> call(
      CreateRouteParams createRouteParams) async {
    return await routeRepository.createRoute(
        route: createRouteParams.routeEntity, file: createRouteParams.file);
  }
}

class CreateRouteParams {
  final RouteEntity routeEntity;
  final File file;
  CreateRouteParams({required this.routeEntity, required this.file});
}
