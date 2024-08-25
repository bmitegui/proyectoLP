import 'package:dartz/dartz.dart';
import 'package:path_finder/core/error/error.dart';
import 'package:path_finder/features/user/data/models/models.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserModel>> login(
      {required String email, required String password});
  Future<Either<Failure, UserModel>> register(
      {required String email,
      required String password,
      required String firstName,
      required String lastName});
  Future<Either<Failure, UserModel>> checkUserAuthentication();
}
