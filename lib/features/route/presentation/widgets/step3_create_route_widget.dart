import 'package:flutter/material.dart';
import 'package:path_finder/core/theme/app_theme.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';
import 'package:path_finder/features/route/presentation/screens/add_ubi_screen.dart';

class Step3CreateRouteWidget extends StatelessWidget {
  final RouteEntity routeEntity;
  final Function(RouteEntity) onChange;
  const Step3CreateRouteWidget(
      {super.key, required this.routeEntity, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (routeEntity.latitude != 0 && routeEntity.longitude != 0)
        Text.rich(
            textAlign: TextAlign.start,
            TextSpan(
                text: 'Latitud: ',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: '${routeEntity.latitude}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(overflow: TextOverflow.ellipsis)),
                ])),
      if (routeEntity.latitude != 0 && routeEntity.longitude != 0)
        Text.rich(
            textAlign: TextAlign.start,
            TextSpan(
                text: 'Longitud: ',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: '${routeEntity.longitude}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(overflow: TextOverflow.ellipsis)),
                ])),
      if (routeEntity.latitude != 0 && routeEntity.longitude != 0)
        const SizedBox(height: 16),
      SizedBox(
          width: double.infinity,
          child: CustomButtonWidget(
              onTap: () async {
                final RouteEntity? route = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddUbiScreen(
                            routeEntity: routeEntity, agregarParada: false)));
                if (route != null) {
                  onChange(route);
                }
              },
              color: colorSeed,
              iconData: Icons.add,
              label: 'Agregar punto'))
    ]);
  }
}
