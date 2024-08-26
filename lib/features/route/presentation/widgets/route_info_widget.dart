import 'package:flutter/material.dart';
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
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade200, width: 2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Image.asset('assets/img/placeholder.jpg',
                              height: 150, fit: BoxFit.fitWidth)),
                      const SizedBox(height: 8),
                      Text(widget.route.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      SizedBox(
                          height: 16,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.route.routeTypes.length,
                              itemBuilder: (context, index) {
                                final routeType =
                                    widget.route.routeTypes[index];

                                return Padding(
                                  padding: EdgeInsets.only(
                                      right: (index !=
                                              widget.route.routeTypes.length -
                                                  1)
                                          ? 8
                                          : 0),
                                  child: Icon(
                                      (routeType == RouteType.aventura)
                                          ? Icons.explore
                                          : (routeType == RouteType.ciudad)
                                              ? Icons.location_city
                                              : (routeType == RouteType.cultura)
                                                  ? Icons.museum
                                                  : Icons.restaurant,
                                      color: teritoryColor_),
                                );
                              })),
                      const SizedBox(height: 16),
                      Text(widget.route.description,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      const Spacer(),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Text(
                            DateFormat('dd/ MM /yy')
                                .format(widget.route.routeDate),
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
