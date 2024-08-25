import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_finder/features/user/data/models/models.dart';

abstract interface class UserLocalDataSource {
  Future<void> logout();
  Future<void> uploadLocalUser({required UserModel userModel});
  UserModel loadLocalUser();
  Future<UserModel?> checkUserAuthentication();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box box;

  UserLocalDataSourceImpl({required this.box});

  @override
  UserModel loadLocalUser() {
    final dynamic userModelJsonBox = box.get('UserModel');
    final Map<String, dynamic> userModelJson = {};
    userModelJsonBox.forEach((key, value) {
      userModelJson[key] = value;
    });
    return UserModel.fromJson(userModelJson);
  }

  @override
  Future<void> uploadLocalUser({required UserModel userModel}) async {
    await box.clear();
    await box.put('UserModel', userModel.toJson());
  }

  @override
  Future<UserModel?> checkUserAuthentication() async {
    final userJson = box.get('UserModel');
    final value = userJson != null && userJson.isNotEmpty;
    if (value) {
      return loadLocalUser();
    } else {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await box.clear();
  }
}
