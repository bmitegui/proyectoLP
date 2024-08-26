import 'package:flutter/material.dart';

class BuildDropdown extends StatelessWidget {
  final String title;
  final String value;
  final Function(String) onChanged;
  const BuildDropdown(
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
      const SizedBox(height: 4),
      DropdownButton<String>(
          value: value,
          items: ['Sonido 1', 'Sonido 2', 'Sonido 3'].map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith()),
            );
          }).toList(),
          onChanged: (value) => onChanged(value!))
    ]);
  }
}
