part of 'routes_bloc.dart';

sealed class RoutesState {
  const RoutesState();
}

final class RoutesInitial extends RoutesState {}

final class RoutesLoading extends RoutesState {}

final class RoutesLoaded extends RoutesState {
  final List<RouteEntity> routes;
  RoutesLoaded({required this.routes});
}

final class RoutesError extends RoutesState {
  final String message;
  RoutesError({required this.message});
}
