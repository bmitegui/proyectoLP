import 'package:dartz/dartz.dart';
import 'package:path_finder/core/error/failures.dart';
import 'package:path_finder/core/usecases/usecase.dart';
import 'package:path_finder/features/user/domain/entities/entities.dart';
import 'package:path_finder/features/user/domain/repositories/repositories.dart';

class Login implements UseCase<User, LoginParams> {
  final UserRepository userRepository;
  Login({required this.userRepository});

  @override
  Future<Either<Failure, User>> call(LoginParams loginParams) async {
    return await userRepository.login(
        email: loginParams.email, password: loginParams.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
