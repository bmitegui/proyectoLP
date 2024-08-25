part of 'user_bloc.dart';

sealed class UserEvent {
  const UserEvent();
}

final class UserInitialEvent extends UserEvent {}

final class LoginEvent extends UserEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

final class LogoutEvent extends UserEvent {
  final User user;
  LogoutEvent({required this.user});
}

final class RegisterEvent extends UserEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  RegisterEvent(
      {required this.email,
      required this.password,
      required this.firstName,
      required this.lastName});
}

final class CheckAuthStatusEvent extends UserEvent {}
