import 'package:dartz/dartz.dart';
import 'package:path_finder/core/error/failures.dart';
import 'package:path_finder/core/usecases/usecase.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';
import 'package:path_finder/features/route/domain/repositories/route_repository.dart';

class GetRoutes implements UseCase<List<RouteEntity>, NoParams> {
  final RouteRepository routeRepository;
  GetRoutes({required this.routeRepository});

  @override
  Future<Either<Failure, List<RouteEntity>>> call(NoParams noParams) async {
    return await routeRepository.getRoutes();
  }
}
