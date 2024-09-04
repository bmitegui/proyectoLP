import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String urlphoto;
  final String phone;
  final String description;
  final int rutas;

  const User(
      {required this.uid,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.urlphoto,
      required this.phone,
      required this.description,
      required this.rutas});
  User copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? urlphoto,
    String? phone,
    String? description,
    int? rutas,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      urlphoto: urlphoto ?? this.urlphoto,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      rutas: rutas ?? this.rutas,
    );
  }

  @override
  List<Object?> get props => [uid];
}
