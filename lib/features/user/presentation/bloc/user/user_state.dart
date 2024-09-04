part of 'user_bloc.dart';

sealed class UserState {
  const UserState();
}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserAuthenticated extends UserState {
  final User user;
  final String? message;
  UserAuthenticated({required this.user, this.message});
}

final class UserUnauthenticated extends UserState {}

final class UserError extends UserState {
  final String message;
  UserError({required this.message});
}
