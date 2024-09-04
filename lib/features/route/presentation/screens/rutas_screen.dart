import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/core/theme/app_theme.dart';
import 'package:path_finder/core/theme/responsive_size.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';
import 'package:path_finder/features/route/presentation/bloc/bloc.dart';
import 'package:path_finder/features/route/presentation/widgets/filtros_rutas.dart';
import 'package:path_finder/features/route/presentation/widgets/horizontal_info_ruta_widget.dart';
import 'package:path_finder/features/route/presentation/widgets/sliver_app_bar_delegate.dart';

class RutasScreen extends StatefulWidget {
  const RutasScreen({super.key});

  @override
  State<RutasScreen> createState() => _RutasScreenState();
}

class _RutasScreenState extends State<RutasScreen> {
  late ScrollController _scrollController;
  RouteType? _routeTypeSelected;
  late List<RouteEntity> routeEntityList;

  @override
  void initState() {
    super.initState();
    routeEntityList = [];
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutesBloc, RoutesState>(builder: (context, state) {
      if (state is RoutesLoaded) {
        if (_routeTypeSelected != null) {
          routeEntityList = state.routes
              .where((route) => route.routeTypes.contains(_routeTypeSelected))
              .toList();
        } else {
          routeEntityList = state.routes;
        }
      }
      return Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: colorSeed,
              title: Text('Rutas',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white)),
              actions: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white))
              ]),
          body: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Column(children: [
                Expanded(
                    child: Scrollbar(
                        controller: _scrollController,
                        radius: const Radius.circular(20),
                        thickness: 0,
                        child: RefreshIndicator(
                            onRefresh: () async {
                              setState(() {
                                _routeTypeSelected = null;
                              });
                            },
                            child: LayoutBuilder(builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return CustomScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  controller: _scrollController,
                                  slivers: [
                                    SliverPersistentHeader(
                                        pinned: true,
                                        delegate: SliverAppBarDelegate(
                                            maxHeight: 50.0.rh(context),
                                            minHeight: 50.0.rh(context),
                                            child: GestureDetector(
                                                onTap: () {
                                                  _scrollController.animateTo(0,
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.easeInOut);
                                                },
                                                child: Container(
                                                    color: const Color.fromARGB(
                                                        255, 248, 248, 248),
                                                    child: Text('Filtros',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium))))),
                                    SliverToBoxAdapter(
                                        child: FiltrosRutas(
                                            routeTypeSelected:
                                                _routeTypeSelected,
                                            onTap: (value) => setState(() {
                                                  _routeTypeSelected = value;
                                                }))),
                                    const SliverToBoxAdapter(
                                        child: SizedBox(height: 16)),
                                    SliverPersistentHeader(
                                        pinned: true,
                                        delegate: SliverAppBarDelegate(
                                            maxHeight: 50.0.rh(context),
                                            minHeight: 50.0.rh(context),
                                            child: GestureDetector(
                                                onTap: () {
                                                  _scrollController.animateTo(0,
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.easeInOut);
                                                },
                                                child: Container(
                                                    color: const Color.fromARGB(
                                                        255, 248, 248, 248),
                                                    child: Text(
                                                        'Lista de rutas',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontSize: 20.rf(
                                                                    context))))))),
                                    SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                            childCount: state is RoutesLoaded
                                                ? routeEntityList.length
                                                : state is RoutesLoading
                                                    ? 4
                                                    : 1,
                                            (BuildContext context, index) {
                                      return state is RoutesLoaded
                                          ? (routeEntityList.isNotEmpty)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16),
                                                  child:
                                                      HorizontalInfoRutaWidget(
                                                        routeTypeSelected: _routeTypeSelected,
                                                          routeEntity: state
                                                              .routes[index]))
                                              : const SizedBox(height: 20)
                                          : Center(
                                              child: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height -
                                                      300,
                                                  child: const Center(
                                                      child: Text(
                                                    'No existen rutas',
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ))));
                                    })),
                                    if ((state is RoutesLoaded &&
                                            routeEntityList.length < 4) ||
                                        state is RoutesError)
                                      const SliverFillRemaining(
                                          hasScrollBody: false,
                                          child: Center()),
                                    if ((state is RoutesLoaded &&
                                            routeEntityList.length < 4) ||
                                        state is RoutesError)
                                      const SliverToBoxAdapter(
                                          child: SizedBox(height: 5))
                                  ]);
                            }))))
              ])));
    });
  }
}
