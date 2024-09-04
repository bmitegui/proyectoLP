import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path_finder/core/error/failures.dart';
import 'package:path_finder/core/usecases/usecase.dart';
import 'package:path_finder/features/user/domain/repositories/repositories.dart';

class UpdateProfileImage implements UseCase<String, UpdateProfileImageParams> {
  final UserRepository userRepository;
  UpdateProfileImage({required this.userRepository});

  @override
  Future<Either<Failure, String>> call(
      UpdateProfileImageParams updateProfileImageParams) async {
    return await userRepository.updateProfileImage(
        uid: updateProfileImageParams.uid, file: updateProfileImageParams.file);
  }
}

class UpdateProfileImageParams {
  final String uid;
  final File file;

  UpdateProfileImageParams({required this.uid, required this.file});
}
