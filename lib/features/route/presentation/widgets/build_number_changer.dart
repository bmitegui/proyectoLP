import 'package:flutter/material.dart';

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
            icon:
                const Icon(Icons.remove, color: Color.fromRGBO(45, 75, 115, 1)),
            onPressed: () {
              if (value - 1 != 0) {
                onTap(value - 1);
              }
            }),
        Text('$value'),
        IconButton(
            icon: const Icon(Icons.add, color: Color.fromRGBO(45, 75, 115, 1)),
            onPressed: () => onTap(value + 1))
      ])
    ]);
  }
}
