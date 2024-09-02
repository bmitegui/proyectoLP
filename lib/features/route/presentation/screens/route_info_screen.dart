import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_finder/core/theme/app_theme.dart';
import 'package:path_finder/core/theme/responsive_size.dart';
import 'package:path_finder/core/theme/theme_config.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';
import 'package:path_finder/features/route/presentation/screens/tour_screen.dart';

class RouteInfoScreen extends StatefulWidget {
  final RouteEntity routeEntity;
  const RouteInfoScreen({super.key, required this.routeEntity});

  @override
  State<RouteInfoScreen> createState() => _RouteInfoScreenState();
}

class _RouteInfoScreenState extends State<RouteInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: colorSeed,
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: Text(widget.routeEntity.name,
                maxLines: 2,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white)),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white))),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Image.network(widget.routeEntity.urlImage,
                      fit: BoxFit.fitWidth)),
              const SizedBox(height: 16),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.routeEntity.routeTypes.map((routeType) {
                    return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                            (routeType == RouteType.aventura)
                                ? Icons.explore
                                : (routeType == RouteType.ciudad)
                                    ? Icons.location_city
                                    : (routeType == RouteType.cultura)
                                        ? Icons.museum
                                        : (routeType == RouteType.gastronomia)
                                            ? Icons.restaurant
                                            : (routeType ==
                                                    RouteType.naturaleza)
                                                ? Icons.nature
                                                : Icons.church,
                            color: teritoryColor_,
                            size: 32.rf(context)));
                  }).toList()),
              const SizedBox(height: 16),
              Text(widget.routeEntity.description),
              const SizedBox(height: 16),
              Text('Itinerario de rutas',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              Column(
                  children: widget.routeEntity.stops.map((stop) {
                final initialDate =
                    DateFormat('hh:mm a').format(stop.initialDate);

                return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: teritoryColorDark,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(children: [
                          Text(initialDate,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white)),
                          const SizedBox(width: 16),
                          Text(stop.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white))
                        ])));
              }).toList())
            ])),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: CustomButtonWidget(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TourScreen())),
                color: teritoryColor_,
                label: 'Ingresar al tour')));
  }
}
