import 'package:flutter/material.dart';
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
            title: Text(widget.routeEntity.name,
                maxLines: 2, textAlign: TextAlign.start),
            centerTitle: true,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios))),
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
                  child: Image.asset('assets/img/placeholder.jpg',
                      height: 200, fit: BoxFit.fitWidth)),
              const SizedBox(height: 16),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.routeEntity.routeTypes.map((routeType) {
                    return Icon(
                        (routeType == RouteType.aventura)
                            ? Icons.explore
                            : (routeType == RouteType.ciudad)
                                ? Icons.location_city
                                : (routeType == RouteType.cultura)
                                    ? Icons.museum
                                    : Icons.restaurant,
                        color: teritoryColor_,
                        size: 32.rf(context));
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
                    '${stop.startTimeHour} ${(stop.startTimeHour > 12) ? 'pm' : 'am'}';

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
