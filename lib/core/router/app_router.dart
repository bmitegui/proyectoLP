import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:path_finder/core/injection_container.dart';
import 'package:path_finder/core/screens/loading_screen.dart';
import 'package:path_finder/core/router/router.dart';
import 'package:path_finder/core/screens/start_screen.dart';
import 'package:path_finder/features/route/presentation/screens/home.dart';
import 'package:path_finder/features/user/presentation/bloc/bloc.dart';
import 'package:path_finder/features/user/presentation/screens/login_screen.dart';
import 'package:path_finder/features/user/presentation/screens/perfil_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userBloc = sl<UserBloc>();
final userBlocListenable = UserBlocListenable(userBloc);

final appRouter = GoRouter(
    navigatorKey: Get.key,
    initialLocation: '/loading',
    refreshListenable: userBlocListenable,
    routes: [
      GoRoute(
          path: '/loading', builder: (context, state) => const LoadingScreen()),
      GoRoute(path: '/start', builder: (context, state) => const StartScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
          path: '/perfil', builder: (context, state) => const PerfilScreen())
    ],
    redirect: (context, state) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      bool seen = preferences.getBool('seen') ?? false;
      final isGoingTo = state.fullPath;

      if (userBloc.state is UserLoading) {
        return null;
      } else if (userBloc.state is UserAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/loading') {
          return '/home';
        }
        if (isGoingTo == '/perfil') {
          return '/perfil';
        }
      } else if (userBloc.state is UserUnauthenticated) {
        if (!seen) {
          return '/start';
        } else if (isGoingTo == '/register') {
          return '/register';
        } else if (isGoingTo != '/login') {
          return '/login';
        }
      }
      return null;
    });
