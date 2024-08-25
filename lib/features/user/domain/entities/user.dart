import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;

  const User(
      {required this.uid,
      required this.email,
      required this.firstName,
      required this.lastName});

  @override
  List<Object?> get props => [uid];
}
