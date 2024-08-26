import 'package:flutter/material.dart';

class BuildSwitch extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;
  const BuildSwitch(
      {super.key,
      required this.title,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold))),
      const SizedBox(width: 16),
      Switch(value: value, onChanged: (value) => onChanged(value))
    ]);
  }
}
