import 'package:flutter/material.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';

class BuildRouteTypes extends StatelessWidget {
  final String title;
  final List<RouteType> selectedRouteTypes;
  final Function(RouteType) onRouteTypeSelect;
  const BuildRouteTypes(
      {super.key,
      required this.title,
      required this.selectedRouteTypes,
      required this.onRouteTypeSelect});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: RouteType.values.map((type) {
            return ChoiceChip(
                label: Text(type.toString().split('.').last),
                selected: selectedRouteTypes.contains(type),
                onSelected: (selected) {
                  onRouteTypeSelect(type);
                },
                selectedColor: const Color.fromRGBO(91, 125, 170, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)));
          }).toList())
    ]);
  }
}
