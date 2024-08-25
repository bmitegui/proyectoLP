import 'package:dartz/dartz.dart';
import 'package:path_finder/core/error/failures.dart';
import 'package:path_finder/core/usecases/usecase.dart';
import 'package:path_finder/features/user/domain/entities/entities.dart';
import 'package:path_finder/features/user/domain/repositories/repositories.dart';

class CheckUserAuthentication implements UseCase<User, NoParams> {
  final UserRepository userRepository;
  CheckUserAuthentication({required this.userRepository});

  @override
  Future<Either<Failure, User>> call(NoParams noParams) async {
    return await userRepository.checkUserAuthentication();
  }
}
