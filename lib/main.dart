import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/core/constants/environment.dart';
import 'package:path_finder/core/injection_container.dart' as di;
import 'package:path_finder/core/router/app_router.dart';
import 'package:path_finder/core/theme/theme.dart';
import 'package:path_finder/features/route/presentation/bloc/bloc.dart';
import 'package:path_finder/features/user/presentation/bloc/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Environment.initializeEnv();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
  userBloc.add(CheckAuthStatusEvent());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => di.sl<UserBloc>()),
          BlocProvider(create: (context) => di.sl<RoutesBloc>())
        ],
        child: MaterialApp.router(
            routeInformationParser: appRouter.routeInformationParser,
            routerDelegate: appRouter.routerDelegate,
            routeInformationProvider: appRouter.routeInformationProvider,
            debugShowCheckedModeBanner: false,
            title: 'Path Finder',
            theme: AppTheme().getTheme(context)));
  }
}
