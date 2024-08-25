import 'package:dartz/dartz.dart';
import 'package:path_finder/core/error/failures.dart';
import 'package:path_finder/core/usecases/usecase.dart';
import 'package:path_finder/features/user/domain/repositories/repositories.dart';

class Logout implements UseCase<void, NoParams> {
  final UserRepository userRepository;
  Logout({required this.userRepository});

  @override
  Future<Either<Failure, void>> call(NoParams noParams) async {
    return await userRepository.logout();
  }
}
