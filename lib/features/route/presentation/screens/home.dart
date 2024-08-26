import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_finder/core/injection_container.dart';
import 'package:path_finder/core/theme/theme_config.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';
import 'package:path_finder/features/route/presentation/bloc/bloc.dart';
import 'package:path_finder/features/route/presentation/widgets/custom_bottom_navigation_bar_widget.dart';
import 'package:path_finder/features/route/presentation/widgets/route_info_widget.dart';
import 'package:path_finder/features/route/presentation/widgets/search_route_widget.dart';
import 'package:path_finder/features/user/presentation/bloc/bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String page;

  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    sl<RoutesBloc>().add(GetRoutesEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    page = 'Home';
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text('Empecemos una aventura!',
                textAlign: TextAlign.center, maxLines: 2)),
        body: BlocConsumer<UserBloc, UserState>(
            listener: (BuildContext context, UserState state) {},
            builder: (context, state) {
              return (state is UserAuthenticated)
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                child: Text.rich(
                                    textAlign: TextAlign.start,
                                    TextSpan(
                                        text: 'Bienvenido de vuelta, ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${state.user.firstName} ${state.user.lastName}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: teritoryColor_))
                                        ]))),
                            const SizedBox(height: 16),
                            Row(children: [
                              Expanded(
                                  child: Text('¿Deseas crear una ruta?',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      maxLines: 2)),
                              const SizedBox(width: 16),
                              CustomButtonWidget(
                                  onTap: () {
                                    GoRouter.of(context).go('/create-route');
                                  },
                                  color: teritoryColor_,
                                  label: 'Comparte tu ruta!')
                            ]),
                            const SizedBox(height: 16),
                            Text('Busca una ruta',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            const SizedBox(
                                width: double.infinity,
                                child: SearchRouteWidget()),
                            const SizedBox(height: 16),
                            Text('Rutas disponibles',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            BlocConsumer<RoutesBloc, RoutesState>(
                                listener: (BuildContext context,
                                    RoutesState state) {},
                                builder: (context, state) {
                                  return (state is RoutesLoaded)
                                      ? Expanded(
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              controller: _scrollController,
                                              itemCount: state.routes.length,
                                              itemBuilder: (context, index) {
                                                final route =
                                                    state.routes[index];
                                                return Padding(
                                                    padding: EdgeInsets.only(
                                                        right: (index !=
                                                                state.routes
                                                                        .length -
                                                                    1)
                                                            ? 16
                                                            : 0),
                                                    child: RouteInfoWidget(
                                                        route: route));
                                              }))
                                      : const Center(
                                          child: CircularProgressIndicator());
                                })
                          ]))
                  : const Center(child: CircularProgressIndicator());
            }),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomBottomNavigationBarWidget(page: page),
        ));
  }
}
