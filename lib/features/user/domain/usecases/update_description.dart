import 'package:dartz/dartz.dart';
import 'package:path_finder/core/error/failures.dart';
import 'package:path_finder/core/usecases/usecase.dart';
import 'package:path_finder/features/user/domain/repositories/repositories.dart';

class UpdateDescription implements UseCase<void, UpdateDescriptionParams> {
  final UserRepository userRepository;
  UpdateDescription({required this.userRepository});

  @override
  Future<Either<Failure, void>> call(
      UpdateDescriptionParams updateDescriptionParams) async {
    return await userRepository.updateDescription(
        uid: updateDescriptionParams.uid,
        description: updateDescriptionParams.description);
  }
}

class UpdateDescriptionParams {
  final String uid;
  final String description;

  UpdateDescriptionParams({required this.uid, required this.description});
}
