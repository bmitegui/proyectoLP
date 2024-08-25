import 'package:dartz/dartz.dart';
import 'package:path_finder/core/error/error.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>?> call(Params params);
}

class NoParams {}
