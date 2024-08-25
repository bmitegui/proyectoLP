import 'package:dartz/dartz.dart';
import 'package:path_finder/core/error/failures.dart';
import 'package:path_finder/core/usecases/usecase.dart';
import 'package:path_finder/features/user/domain/entities/entities.dart';
import 'package:path_finder/features/user/domain/repositories/repositories.dart';

class Register implements UseCase<User, RegisterParams> {
  final UserRepository userRepository;
  Register({required this.userRepository});

  @override
  Future<Either<Failure, User>> call(RegisterParams registerParams) async {
    return await userRepository.register(
        email: registerParams.email,
        password: registerParams.password,
        firstName: registerParams.firstName,
        lastName: registerParams.lastName);
  }
}

class RegisterParams {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  RegisterParams(
      {required this.email,
      required this.password,
      required this.firstName,
      required this.lastName});
}
