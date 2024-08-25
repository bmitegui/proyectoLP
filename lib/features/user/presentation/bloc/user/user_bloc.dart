import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/core/error/error.dart';
import 'package:path_finder/core/usecases/usecase.dart';
import 'package:path_finder/features/user/domain/entities/entities.dart';
import 'package:path_finder/features/user/domain/usecases/usecases.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Login loginUseCase;
  final Register registerUseCase;
  final Logout logoutUseCase;
  final CheckUserAuthentication checkUserAuthentication;

  UserBloc(
      {required this.loginUseCase,
      required this.registerUseCase,
      required this.logoutUseCase,
      required this.checkUserAuthentication})
      : super(UserInitial()) {
    on<UserInitialEvent>(_onUserInitialRequest);
    on<LoginEvent>(_onLoginEventRequest);
    on<RegisterEvent>(_onRegisterRequest);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusRequest);
    on<LogoutEvent>(_onLogoutEventRequest);
  }

  Future<void> _onLogoutEventRequest(
      LogoutEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final failureOrSuccess = await logoutUseCase(NoParams());
    failureOrSuccess.fold((failure) {
      emit(UserError(message: _mapFailureToMessage(failure)));
      emit(UserAuthenticated(user: event.user));
    }, (user) async {
      emit(UserUnauthenticated());
    });
  }

  Future<void> _onUserInitialRequest(
      UserInitialEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    emit(UserUnauthenticated());
  }

  Future<void> _onLoginEventRequest(
      LoginEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final failureOrUser = await loginUseCase(
        LoginParams(email: event.email, password: event.password));
    failureOrUser.fold((failure) {
      emit(UserError(message: _mapFailureToMessage(failure)));
    }, (user) async {
      emit(UserAuthenticated(user: user));
    });
  }

  Future<void> _onCheckAuthStatusRequest(
      CheckAuthStatusEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final failureOrValue = await checkUserAuthentication(NoParams());
    failureOrValue.fold((failure) {
      emit(UserError(message: _mapFailureToMessage(failure)));
      emit(UserUnauthenticated());
    }, (user) async {
      emit(UserAuthenticated(user: user));
    });
  }

  Future<void> _onRegisterRequest(
      RegisterEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final failureOrUser = await registerUseCase(RegisterParams(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName));

    failureOrUser.fold((failure) {
      emit(UserError(message: _mapFailureToMessage(failure)));
    }, (user) async {
      emit(UserAuthenticated(user: user));
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
