part of 'routes_bloc.dart';

sealed class RoutesEvent {
  const RoutesEvent();
}

final class RoutesInitialEvent extends RoutesEvent {}

final class GetRoutesEvent extends RoutesEvent {}

final class CreateRouteEvent extends RoutesEvent {
  final List<RouteEntity> listRoutes;
  final RouteEntity routeEntity;
  final File file;
  CreateRouteEvent(
      {required this.listRoutes,
      required this.routeEntity,
      required this.file});
}
