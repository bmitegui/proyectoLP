import 'package:path_finder/features/user/domain/entities/entities.dart';

class UserModel extends User {
  const UserModel(
      {required super.uid,
      required super.email,
      required super.firstName,
      required super.lastName});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        uid: json['uid'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName']);
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
