import 'package:flutter/material.dart';
import 'package:path_finder/core/theme/theme.dart';
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
      const SizedBox(height: 16),
      Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: RouteType.values.map((type) {
            return ChoiceChip(
                backgroundColor: Colors.white,
                checkmarkColor: Colors.white,
                label: Text(type.toString().split('.').last,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: selectedRouteTypes.contains(type)
                            ? Colors.white
                            : const Color.fromARGB(255, 0, 45, 49))),
                selected: selectedRouteTypes.contains(type),
                onSelected: (selected) {
                  onRouteTypeSelect(type);
                },
                selectedColor: colorSeed,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)));
          }).toList())
    ]);
  }
}
