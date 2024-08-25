import 'package:dio/dio.dart';
import 'package:path_finder/core/constants/api_constants.dart';
import 'package:path_finder/core/error/error.dart';
import 'package:path_finder/features/user/data/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

abstract class UserRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register(
      {required String email,
      required String password,
      required String firstName,
      required String lastName});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio cliente;
  UserRemoteDataSourceImpl({required this.cliente});

  @override
  Future<UserModel> login({required String email, required String password}) async {
    final auth = fb.FirebaseAuth.instance;
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      final user = userCredential.user;
      if (user == null) {
        throw const ServerException();
      }

      final listName = user.displayName!.split(' ');

      return UserModel(
          uid: user.uid,
          email: user.email!,
          firstName: listName[0],
          lastName: listName[1]);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException();
    }
  }

  @override
  Future<UserModel> register(
      {required String email,
      required String password,
      required String firstName,
      required String lastName}) async {
    try {
      final result = await cliente.post(registerUrl,
          data: {
            'email': email,
            'password': password,
            'firstName': firstName,
            'lastName': lastName
          },
          options: Options(contentType: Headers.jsonContentType));

      final status = result.data['status'];
      final message = result.data['message'];
      if (status == 'success') {
        final uid = result.data['uid'];
        return UserModel(
            uid: uid, email: email, firstName: firstName, lastName: lastName);
      } else {
        throw ServerException(message: message);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException();
    }
  }
}
