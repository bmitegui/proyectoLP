import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_finder/core/constants/api_constants.dart';
import 'package:path_finder/core/error/error.dart';
import 'package:path_finder/features/route/data/models/models.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';

abstract class RouteRemoteDataSource {
  Future<List<RouteModel>> getRoutes();
  Future<RouteModel> createRoute(
      {required RouteEntity route, required File file});
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

  @override
  Future<RouteModel> createRoute(
      {required RouteEntity route, required File file}) async {
    try {
      final fileName = file.path.split('/').last;
      final storageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      route = route.copyWith(urlImage: downloadUrl);

      final result = await cliente.post(createRouteUrl,
          data: route.toJson(),
          options: Options(contentType: Headers.jsonContentType));

      final status = result.data['status'];
      final message = result.data['message'];
      if (status == 'success') {
        final id = result.data['id'];
        return RouteModel(
            id: id,
            name: route.name,
            description: route.description,
            peopleNumber: route.peopleNumber,
            guidesNumber: route.guidesNumber,
            alertRange: route.alertRange,
            showInfo: route.showInfo,
            alertSound: route.alertSound,
            isPublic: route.isPublic,
            initialDate: route.initialDate,
            routeTypes: route.routeTypes,
            stops: route.stops,
            latitude: route.latitude,
            longitude: route.longitude,
            urlImage: downloadUrl);
      } else {
        throw ServerException(message: message);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException();
    }
  }
}
