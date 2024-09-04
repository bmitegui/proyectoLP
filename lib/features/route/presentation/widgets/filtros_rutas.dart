import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/core/theme/app_theme.dart';
import 'package:path_finder/core/theme/theme_config.dart';
import 'package:path_finder/features/route/domain/entities/route.dart';
import 'package:path_finder/features/route/presentation/bloc/routes/routes_bloc.dart';

class FiltrosRutas extends StatefulWidget {
  final RouteType? routeTypeSelected;
  final Function(RouteType?) onTap;

  const FiltrosRutas(
      {super.key, required this.routeTypeSelected, required this.onTap});

  @override
  State<FiltrosRutas> createState() => _FiltrosRutasState();
}

class _FiltrosRutasState extends State<FiltrosRutas> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutesBloc, RoutesState>(builder: (context, state) {
      return (state is RoutesLoaded)
          ? Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: RouteType.values
                  .map((routeType) => buildFiltro(routeType: routeType))
                  .toList())
          : const Center(child: CircularProgressIndicator());
    });
  }

  Widget buildFiltro({required RouteType routeType}) {
    return GestureDetector(
        onTap: () {
          if (widget.routeTypeSelected == routeType) {
            widget.onTap(null);
            ;
          } else {
            widget.onTap(routeType);
          }
        },
        child: Container(
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width / 2.5,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                border: Border.all(color: colorSeed),
                borderRadius: BorderRadius.circular(20),
                color: (widget.routeTypeSelected != routeType)
                    ? Colors.white
                    : teritoryColor_),
            child: Column(children: [
              Icon(
                  (routeType == RouteType.aventura)
                      ? Icons.explore
                      : (routeType == RouteType.ciudad)
                          ? Icons.location_city
                          : (routeType == RouteType.cultura)
                              ? Icons.museum
                              : (routeType == RouteType.gastronomia)
                                  ? Icons.restaurant
                                  : (routeType == RouteType.naturaleza)
                                      ? Icons.nature
                                      : Icons.church,
                  color: (widget.routeTypeSelected == routeType)
                      ? Colors.white
                      : teritoryColor_),
              const SizedBox(height: 8),
              Text(routeType.name,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: (widget.routeTypeSelected == routeType)
                          ? Colors.white
                          : teritoryColor_))
            ])));
  }
}
