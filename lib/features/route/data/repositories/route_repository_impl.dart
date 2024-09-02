import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path_finder/core/error/error.dart';
import 'package:path_finder/core/network/network_info.dart';
import 'package:path_finder/features/route/data/datasources/datasources.dart';
import 'package:path_finder/features/route/data/models/route_model.dart';
import 'package:path_finder/features/route/domain/entities/route.dart';
import 'package:path_finder/features/route/domain/repositories/route_repository.dart';

class RouteRepositoryImpl implements RouteRepository {
  final NetworkInfo networkInfo;
  final RouteRemoteDataSource routeRemoteDataSource;

  RouteRepositoryImpl(
      {required this.networkInfo, required this.routeRemoteDataSource});

  @override
  Future<Either<Failure, List<RouteModel>>> getRoutes() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await routeRemoteDataSource.getRoutes();
        return Right(remoteUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, RouteModel>> createRoute(
      {required RouteEntity route, required File file}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRoute =
            await routeRemoteDataSource.createRoute(route: route, file: file);
        return Right(remoteRoute);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}
