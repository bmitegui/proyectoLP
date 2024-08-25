import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_finder/features/route/data/datasources/datasources.dart';
import 'package:path_finder/features/route/data/repositories/repositories.dart';
import 'package:path_finder/features/route/domain/repositories/route_repository.dart';
import 'package:path_finder/features/route/domain/usecases/usecases.dart';
import 'package:path_finder/features/route/presentation/bloc/bloc.dart';
import 'package:path_finder/firebase_options.dart';
import 'package:path_provider/path_provider.dart';
import 'network/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_finder/features/user/data/datasources/datasources.dart';
import 'package:path_finder/features/user/data/repositories/repositories.dart';
import 'package:path_finder/features/user/domain/repositories/repositories.dart';
import 'package:path_finder/features/user/domain/usecases/usecases.dart';
import 'package:path_finder/features/user/presentation/bloc/bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Core
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  Hive.init((await getApplicationDocumentsDirectory()).path);
  sl.registerLazySingleton<Box<dynamic>>(() => Hive.box('UserModel'),
      instanceName: 'UserModel');
  await Hive.openBox('UserModel');

  //! Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(cliente: sl<Dio>()));
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl(
      box: sl<Box<dynamic>>(instanceName: 'UserModel')));

  sl.registerLazySingleton<RouteRemoteDataSource>(
      () => RouteRemoteDataSourceImpl(cliente: sl<Dio>()));

  //! Repository
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
      networkInfo: sl<NetworkInfo>(),
      userRemoteDataSource: sl<UserRemoteDataSource>(),
      userLocalDataSource: sl<UserLocalDataSource>()));

  sl.registerLazySingleton<RouteRepository>(() => RouteRepositoryImpl(
      networkInfo: sl<NetworkInfo>(),
      routeRemoteDataSource: sl<RouteRemoteDataSource>()));

  //! Use cases
  sl.registerLazySingleton<Register>(
      () => Register(userRepository: sl<UserRepository>()));
  sl.registerLazySingleton<CheckUserAuthentication>(
      () => CheckUserAuthentication(userRepository: sl<UserRepository>()));
  sl.registerLazySingleton<Login>(
      () => Login(userRepository: sl<UserRepository>()));
  sl.registerLazySingleton<Logout>(
      () => Logout(userRepository: sl<UserRepository>()));

  sl.registerLazySingleton<GetRoutes>(
      () => GetRoutes(routeRepository: sl<RouteRepository>()));

  //! Blocs
  sl.registerLazySingleton<UserBloc>(() => UserBloc(
      loginUseCase: sl<Login>(),
      registerUseCase: sl<Register>(),
      logoutUseCase: sl<Logout>(),
      checkUserAuthentication: sl<CheckUserAuthentication>()));

  sl.registerLazySingleton<RoutesBloc>(
      () => RoutesBloc(getRoutesUseCase: sl<GetRoutes>()));
}
