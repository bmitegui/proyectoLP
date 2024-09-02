import 'package:flutter/material.dart';
import 'package:path_finder/core/theme/app_theme.dart';

class BuildDatePicker extends StatelessWidget {
  final String title;
  final DateTime dateTime;
  final Function(DateTime) onDateChanged;
  const BuildDatePicker(
      {super.key,
      required this.title,
      required this.dateTime,
      required this.onDateChanged});

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
      TextButton(
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: dateTime,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              onDateChanged(pickedDate);
            }
          },
          child: Text('${dateTime.day}/${dateTime.month}/${dateTime.year}',
              style: Theme.of(context).textTheme.bodyMedium))
    ]);
  }
}
