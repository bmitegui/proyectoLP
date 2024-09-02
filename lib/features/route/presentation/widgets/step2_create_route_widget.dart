import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_finder/core/theme/app_theme.dart';
import 'package:path_finder/core/theme/theme_config.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';
import 'package:path_finder/features/route/presentation/screens/add_ubi_screen.dart';

class Step2CreateRouteWidget extends StatelessWidget {
  final RouteEntity routeEntity;
  final Function(RouteEntity) onChange;
  const Step2CreateRouteWidget(
      {super.key, required this.onChange, required this.routeEntity});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Column(
          mainAxisSize: MainAxisSize.min,
          children: routeEntity.stops.map((stop) {
            final initialDate = DateFormat('hh:mm a').format(stop.initialDate);
            final endDate = DateFormat('hh:mm a').format(stop.endDate);
            return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: teritoryColorDark,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(children: [
                      Column(children: [
                        Text(stop.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white)),
                        const SizedBox(height: 8),
                        Row(children: [
                          Text(initialDate,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white)),
                          const SizedBox(width: 16),
                          Text(endDate,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white))
                        ])
                      ]),
                      const SizedBox(width: 16),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            List<StopEntity> stops =
                                List.from(routeEntity.stops);
                            stops.remove(stop);
                            onChange(routeEntity.copyWith(stops: stops));
                          },
                          icon: const Icon(Icons.close, color: Colors.white))
                    ])));
          }).toList()),
      if (routeEntity.stops.isNotEmpty) const SizedBox(height: 16),
      SizedBox(
          width: double.infinity,
          child: CustomButtonWidget(
              onTap: () async {
                final RouteEntity? route = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddUbiScreen(
                            routeEntity: routeEntity, agregarParada: true)));
                if (route != null) {
                  onChange(route);
                }
              },
              color: colorSeed,
              iconData: Icons.add,
              label: 'Agregar una parada'))
    ]);
  }
}
