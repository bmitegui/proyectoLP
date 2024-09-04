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

final class UpdateDescriptionEvent extends UserEvent {
  final User user;
  final String description;

  UpdateDescriptionEvent({required this.user, required this.description});
}

final class UpdateProfileImageEvent extends UserEvent {
  final User user;
  final File file;
  UpdateProfileImageEvent({required this.user, required this.file});
}
