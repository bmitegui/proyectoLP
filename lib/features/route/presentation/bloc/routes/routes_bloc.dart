import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/core/error/error.dart';
import 'package:path_finder/core/usecases/usecase.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';
import 'package:path_finder/features/route/domain/usecases/usecases.dart';

part 'routes_event.dart';
part 'routes_state.dart';

class RoutesBloc extends Bloc<RoutesEvent, RoutesState> {
  final GetRoutes getRoutesUseCase;

  RoutesBloc({required this.getRoutesUseCase}) : super(RoutesInitial()) {
    on<RoutesInitialEvent>(_onRoutesInitialEventRequest);
    on<GetRoutesEvent>(_onGetRoutesEventRequest);
  }

  Future<void> _onRoutesInitialEventRequest(
      RoutesInitialEvent event, Emitter<RoutesState> emit) async {
    emit(RoutesLoading());
    emit(RoutesLoaded(routes: []));
  }

  Future<void> _onGetRoutesEventRequest(
      GetRoutesEvent event, Emitter<RoutesState> emit) async {
    emit(RoutesLoading());

    final failureOrListRoutes = await getRoutesUseCase(NoParams());
    failureOrListRoutes.fold((failure) {
      emit(RoutesError(message: _mapFailureToMessage(failure)));
      emit(RoutesLoaded(routes: []));
    }, (routes) async {
      emit(RoutesLoaded(routes: routes));
    });
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return failure.message;
    } else {
      return 'Unexpected error';
    }
  }
}
