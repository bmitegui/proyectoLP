import 'package:path_finder/features/user/domain/entities/entities.dart';

class UserModel extends User {
  const UserModel(
      {required super.uid,
      required super.email,
      required super.firstName,
      required super.lastName,
      required super.urlphoto,
      required super.description,
      required super.phone,
      required super.rutas});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        uid: json['uid'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        urlphoto: json['urlphoto'],
        description: json['description'],
        phone: json['phone'],
        rutas: json['rutas']);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName
    };
  }
}
