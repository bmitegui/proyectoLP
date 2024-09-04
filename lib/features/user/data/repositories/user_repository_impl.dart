import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path_finder/core/error/error.dart';
import 'package:path_finder/core/network/network_info.dart';
import 'package:path_finder/features/user/data/datasources/datasources.dart';
import 'package:path_finder/features/user/data/models/models.dart';
import 'package:path_finder/features/user/domain/repositories/repositories.dart';

class UserRepositoryImpl implements UserRepository {
  final NetworkInfo networkInfo;
  final UserRemoteDataSource userRemoteDataSource;
  final UserLocalDataSource userLocalDataSource;
  UserRepositoryImpl(
      {required this.networkInfo,
      required this.userRemoteDataSource,
      required this.userLocalDataSource});

  @override
  Future<Either<Failure, UserModel>> register(
      {required String email,
      required String password,
      required String firstName,
      required String lastName}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await userRemoteDataSource.register(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName);
        await userLocalDataSource.uploadLocalUser(userModel: remoteUser);
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
  Future<Either<Failure, UserModel>> checkUserAuthentication() async {
    try {
      final localUser = await userLocalDataSource.checkUserAuthentication();
      if (localUser != null) {
        return Right(localUser);
      } else {
        return Left(ServerFailure(message: 'No se encuentra autenticado'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserModel>> login(
      {required String email, required String password}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser =
            await userRemoteDataSource.login(email: email, password: password);
        await userLocalDataSource.uploadLocalUser(userModel: remoteUser);
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
  Future<Either<Failure, void>> logout() async {
    try {
      await userLocalDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateDescription(
      {required String uid, required String description}) async {
    try {
      await userRemoteDataSource.updateDescription(
          uid: uid, description: description);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> updateProfileImage(
      {required String uid, required File file}) async {
    try {
      final url =
          await userRemoteDataSource.updateProfileImage(uid: uid, file: file);
      return Right(url);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
