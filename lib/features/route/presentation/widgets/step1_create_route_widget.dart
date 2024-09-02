import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';
import 'package:path_finder/features/route/presentation/widgets/build_date_picker.dart';
import 'package:path_finder/features/route/presentation/widgets/build_dropdown.dart';
import 'package:path_finder/features/route/presentation/widgets/build_number_changer.dart';
import 'package:path_finder/features/route/presentation/widgets/build_range_slider.dart';
import 'package:path_finder/features/route/presentation/widgets/build_route_types.dart';
import 'package:path_finder/features/route/presentation/widgets/build_switch.dart';
import 'package:path_finder/features/route/presentation/widgets/pick_image_widget.dart';
import 'package:path_finder/features/user/presentation/widgets/custom_text_field.dart';

class Step1CreateRouteWidget extends StatefulWidget {
  final RouteEntity route;
  final File? file;
  final TextEditingController nameRoute;
  final TextEditingController descriptionRoute;
  final Function(RouteEntity) onChange;
  final Function(File) onPickImage;

  const Step1CreateRouteWidget(
      {super.key,
      required this.route,
      required this.file,
      required this.nameRoute,
      required this.descriptionRoute,
      required this.onChange,
      required this.onPickImage});

  @override
  State<Step1CreateRouteWidget> createState() => _Step1CreateRouteWidgetState();
}

class _Step1CreateRouteWidgetState extends State<Step1CreateRouteWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomTextField(
              title: 'Nombre de la ruta',
              hintText: 'Ingrese el nombre de la ruta',
              textEditingController: widget.nameRoute,
              iconData: Icons.gps_fixed),
          const SizedBox(height: 16),
          CustomTextField(
              title: 'Descripción de la ruta',
              hintText: 'Ingrese la descripción de la ruta',
              textEditingController: widget.descriptionRoute,
              maxLines: 2,
              iconData: Icons.gps_fixed),
          const SizedBox(height: 16),
          PickImageWidget(
              file: widget.file,
              onPickImage: (value) => widget.onPickImage(value)),
          const SizedBox(height: 16),
          BuildNumberChanger(
              title: 'Cantidad de personas',
              value: widget.route.peopleNumber,
              onTap: (value) =>
                  widget.onChange(widget.route.copyWith(peopleNumber: value))),
          const SizedBox(height: 16),
          BuildNumberChanger(
              title: 'Número de guías',
              value: widget.route.guidesNumber,
              onTap: (value) =>
                  widget.onChange(widget.route.copyWith(guidesNumber: value))),
          const SizedBox(height: 16),
          BuildRangeSlider(
              title: 'Rango de alerta',
              value: widget.route.alertRange,
              onChanged: (value) =>
                  widget.onChange(widget.route.copyWith(alertRange: value))),
          const SizedBox(height: 16),
          BuildSwitch(
              title: 'Mostrar información del lugar',
              value: widget.route.showInfo,
              onChanged: (value) =>
                  widget.onChange(widget.route.copyWith(showInfo: value))),
          const SizedBox(height: 16),
          BuildSwitch(
              title: 'Ruta pública',
              value: widget.route.isPublic,
              onChanged: (value) =>
                  widget.onChange(widget.route.copyWith(isPublic: value))),
          const SizedBox(height: 16),
          BuildDropdown(
              title: 'Sonido de alerta',
              value: widget.route.alertSound,
              onChanged: (value) =>
                  widget.onChange(widget.route.copyWith(alertSound: value))),
          const SizedBox(height: 16),
          BuildDatePicker(
              title: 'Fecha de la ruta',
              dateTime: widget.route.initialDate,
              onDateChanged: (value) =>
                  widget.onChange(widget.route.copyWith(initialDate: value))),
          const SizedBox(height: 16),
          BuildRouteTypes(
              title: 'Tipo de ruta',
              selectedRouteTypes: widget.route.routeTypes,
              onRouteTypeSelect: (value) {
                List<RouteType> selectedRouteTypes =
                    List.from(widget.route.routeTypes);
                if (selectedRouteTypes.contains(value)) {
                  selectedRouteTypes.remove(value);
                } else {
                  selectedRouteTypes.add(value);
                }
                widget.onChange(
                    widget.route.copyWith(routeTypes: selectedRouteTypes));
              })
        ]));
  }
}
