import 'package:flutter/material.dart';
import 'package:path_finder/core/theme/responsive_size.dart';
import 'package:path_finder/core/theme/theme_config.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';
import 'package:intl/intl.dart';
import 'package:path_finder/features/route/presentation/screens/route_info_screen.dart';

class RouteInfoWidget extends StatefulWidget {
  final RouteEntity route;
  const RouteInfoWidget({super.key, required this.route});

  @override
  State<RouteInfoWidget> createState() => _RouteInfoWidgetState();
}

class _RouteInfoWidgetState extends State<RouteInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RouteInfoScreen(routeEntity: widget.route))),
        child: Container(
            width: 200,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          clipBehavior: Clip.hardEdge,
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade200, width: 2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: FadeInImage.assetNetwork(
                              placeholder: 'assets/img/placeholder.jpg',
                              image: widget.route.urlImage,
                              fit: BoxFit.fill,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return const Center(
                                    child:
                                        Icon(Icons.error, color: Colors.red));
                              })),
                      const SizedBox(height: 8),
                      Text(widget.route.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.route.routeTypes.map((routeType) {
                            return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Icon(
                                    (routeType == RouteType.aventura)
                                        ? Icons.explore
                                        : (routeType == RouteType.ciudad)
                                            ? Icons.location_city
                                            : (routeType == RouteType.cultura)
                                                ? Icons.museum
                                                : (routeType ==
                                                        RouteType.gastronomia)
                                                    ? Icons.restaurant
                                                    : (routeType ==
                                                            RouteType
                                                                .naturaleza)
                                                        ? Icons.nature
                                                        : Icons.church,
                                    color: teritoryColor_));
                          }).toList()),
                      const SizedBox(height: 8),
                      Expanded(
                          child: Text(widget.route.description,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium)),
                      const SizedBox(height: 8),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Text(
                            DateFormat('dd/ MM /yy')
                                .format(widget.route.initialDate),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold))
                      ])
                    ]))));
  }
}
