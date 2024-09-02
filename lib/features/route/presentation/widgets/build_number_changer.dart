import 'package:flutter/material.dart';
import 'package:path_finder/core/theme/app_theme.dart';

class BuildNumberChanger extends StatelessWidget {
  final String title;
  final int value;
  final Function(int) onTap;
  const BuildNumberChanger(
      {super.key,
      required this.title,
      required this.value,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold))),
      Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
            icon: Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color.fromARGB(255, 0, 45, 49)),
                    borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.remove, color: colorSeed)),
            onPressed: () {
              if (value - 1 != 0) {
                onTap(value - 1);
              }
            }),
        Text('$value'),
        IconButton(
            icon: Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color.fromARGB(255, 0, 45, 49)),
                    borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.add, color: colorSeed)),
            onPressed: () => onTap(value + 1))
      ])
    ]);
  }
}
