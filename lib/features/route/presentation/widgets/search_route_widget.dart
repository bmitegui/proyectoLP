import 'package:flutter/material.dart';
import 'package:path_finder/core/theme/responsive_size.dart';

class SearchRouteWidget extends StatelessWidget {
  const SearchRouteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () {},
        iconAlignment: IconAlignment.start,
        icon: const Icon(Icons.search, color: Colors.black54),
        style: ElevatedButton.styleFrom(
            alignment: Alignment.centerLeft,
            backgroundColor: Colors.grey.shade200,
            padding: EdgeInsets.symmetric(
                vertical: 10.rh(context), horizontal: 20.rh(context)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.shade200))),
        label: Text('Explora nuevos lugares',
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black54),
            overflow: TextOverflow.ellipsis));
  }
}
