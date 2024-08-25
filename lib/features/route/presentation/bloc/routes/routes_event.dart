part of 'routes_bloc.dart';

sealed class RoutesEvent {
  const RoutesEvent();
}

final class RoutesInitialEvent extends RoutesEvent {}

final class GetRoutesEvent extends RoutesEvent {}
