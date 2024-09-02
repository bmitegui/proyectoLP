import 'package:flutter/material.dart';

class BuildRangeSlider extends StatelessWidget {
  final String title;
  final double value;
  final Function(double) onChanged;
  const BuildRangeSlider(
      {super.key,
      required this.title,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Row(children: [
        Expanded(
            child: Slider(
                value: value,
                min: 1,
                max: 10,
                divisions: 9,
                label: value.round().toString(),
                onChanged: (value) => onChanged(value))),
        const SizedBox(width: 4),
        Text('$value m',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold))
      ])
    ]);
  }
}
