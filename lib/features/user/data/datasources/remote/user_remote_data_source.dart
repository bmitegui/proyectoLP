import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  Future<void> updateDescription(
      {required String uid, required String description});

  Future<String> updateProfileImage({required String uid, required File file});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio cliente;
  UserRemoteDataSourceImpl({required this.cliente});

  @override
  Future<UserModel> login(
      {required String email, required String password}) async {
    final auth = fb.FirebaseAuth.instance;
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      final user = userCredential.user;
      if (user == null) {
        throw const ServerException();
      }

      final result = await cliente.get(loginUrl,
          data: {'uid': user.uid},
          options: Options(contentType: Headers.jsonContentType));

      final status = result.data['status'];
      if (status == 'success') {
        return UserModel.fromJson(result.data);
      } else {
        throw const ServerException(message: 'Ha ocurrido un error');
      }
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
            uid: uid,
            email: email,
            firstName: firstName,
            lastName: lastName,
            phone: '',
            urlphoto: '',
            description: '',
            rutas: 0);
      } else {
        throw ServerException(message: message);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException();
    }
  }

  @override
  Future<void> updateDescription(
      {required String uid, required String description}) async {
    try {
      final result = await cliente.post(updateDescriptionUserUrl,
          data: {'uid': uid, 'description': description},
          options: Options(contentType: Headers.jsonContentType));

      final status = result.data['status'];
      if (status == 'success') {
        return;
      } else {
        throw const ServerException(message: 'Ha ocurrido un error');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException();
    }
  }

  @override
  Future<String> updateProfileImage(
      {required String uid, required File file}) async {
    try {
      final fileName = file.path.split('/').last;
      final storageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      final result = await cliente.post(updateProfileImageUrl,
          data: {'uid': uid, 'urlImage': downloadUrl},
          options: Options(contentType: Headers.jsonContentType));

      final status = result.data['status'];
      if (status == 'success') {
        return downloadUrl;
      } else {
        throw const ServerException(message: 'Ha ocurrido un error');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException();
    }
  }
}
