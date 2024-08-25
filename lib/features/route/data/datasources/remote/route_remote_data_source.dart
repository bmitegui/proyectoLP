import 'package:dio/dio.dart';
import 'package:path_finder/core/constants/api_constants.dart';
import 'package:path_finder/core/error/error.dart';
import 'package:path_finder/features/route/data/models/models.dart';

abstract class RouteRemoteDataSource {
  Future<List<RouteModel>> getRoutes();
}

class RouteRemoteDataSourceImpl implements RouteRemoteDataSource {
  final Dio cliente;
  RouteRemoteDataSourceImpl({required this.cliente});
  @override
  Future<List<RouteModel>> getRoutes() async {
    try {
      final result = await cliente.get(getRoutesUrl,
          options: Options(contentType: Headers.jsonContentType));

      if (result.statusCode == 200) {
        final List<RouteModel> listRoutes = (result.data as List)
            .map((routeJson) => RouteModel.fromJson(routeJson))
            .toList();
        return listRoutes;
      } else {
        throw const ServerException();
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException();
    }
  }
}
