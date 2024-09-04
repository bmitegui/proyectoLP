import 'package:flutter/material.dart';
import 'package:path_finder/core/theme/app_theme.dart';
import 'package:path_finder/core/theme/responsive_size.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';
import 'package:path_finder/features/route/presentation/screens/route_info_screen.dart';

class HorizontalInfoRutaWidget extends StatelessWidget {
  final RouteEntity routeEntity;
  final RouteType? routeTypeSelected;

  const HorizontalInfoRutaWidget({super.key, required this.routeEntity, required this.routeTypeSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RouteInfoScreen(routeEntity: routeEntity))),
        child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: colorSeed)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    radius: 40.rf(context),
                    foregroundImage: NetworkImage(routeEntity.urlImage),
                    child: Icon(Icons.collections,
                        size: 40.rf(context), color: Colors.grey)),
                const SizedBox(width: 16),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(routeEntity.name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2),
                      const SizedBox(height: 8),
                      Text(routeEntity.description,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2)
                    ]))
              ])
            ])));
  }
}
