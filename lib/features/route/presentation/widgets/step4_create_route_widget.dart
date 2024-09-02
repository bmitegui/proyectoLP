import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';

class Step4CreateRouteWidget extends StatelessWidget {
  final RouteEntity routeEntity;
  final String name;
  final String description;
  final File? file;
  const Step4CreateRouteWidget(
      {super.key,
      required this.routeEntity,
      required this.file,
      required this.name,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      builInfo(context: context, title: 'Nombre', description: name),
      builInfo(
          context: context, title: 'Descripción', description: description),
      Container(
          clipBehavior: Clip.hardEdge,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: (file == null)
              ? Image.asset('assets/img/placeholder.jpg',
                  height: 150, fit: BoxFit.fitWidth)
              : Image.file(file!, height: 150, fit: BoxFit.fitWidth)),
      builInfo(
          context: context,
          title: 'Cantidad de personas',
          description: routeEntity.peopleNumber.toString()),
      builInfo(
          context: context,
          title: 'Número de guías',
          description: routeEntity.guidesNumber.toString()),
      builInfo(
          context: context,
          title: 'Rango de alerta',
          description: routeEntity.alertRange.toString()),
      builInfo(
          context: context,
          title: 'Mostrar información',
          description: routeEntity.showInfo ? 'Sí' : 'No'),
      builInfo(
          context: context,
          title: 'Ruta pública',
          description: routeEntity.isPublic ? 'Sí' : 'No'),
      builInfo(
          context: context,
          title: 'Sonido de alerta',
          description: routeEntity.alertSound),
      builInfo(
          context: context,
          title: 'Fecha de la ruta',
          description:
              DateFormat('dd/ MM /yy').format(routeEntity.initialDate)),
      builInfo(
          context: context,
          title: 'Tipo de ruta',
          description: routeEntity.routeTypes
              .map((tipo) => tipo.name)
              .toList()
              .join(', ')),
      builInfo(
          context: context,
          title: 'Paradas',
          description:
              '\n${routeEntity.stops.map((stop) => '${stop.name} (${stop.latitude},${stop.longitude})').toList().join('\n')}'),
      builInfo(
          context: context,
          title: 'Latitud',
          description: routeEntity.latitude.toString()),
      builInfo(
          context: context,
          title: 'Longitud',
          description: routeEntity.longitude.toString())
    ]);
  }

  Widget builInfo(
      {required BuildContext context,
      required String title,
      required String description}) {
    return Text.rich(
        textAlign: TextAlign.start,
        TextSpan(
            text: '$title: ',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(overflow: TextOverflow.ellipsis))
            ]));
  }
}
