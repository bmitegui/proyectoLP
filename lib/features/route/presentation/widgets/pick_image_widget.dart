import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_finder/core/utils/pick_image.dart';

class PickImageWidget extends StatelessWidget {
  final File? file;
  final Function(File) onPickImage;
  const PickImageWidget(
      {super.key, required this.file, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
          onTap: () async {
            File? pickedImage = await pickImage(false);
            if (pickedImage != null) {
              onPickImage(pickedImage);
            }
          },
          child: Container(
              clipBehavior: Clip.hardEdge,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: (file == null)
                  ? Image.asset('assets/img/placeholder.jpg',
                      height: 150, fit: BoxFit.fitWidth)
                  : Image.file(file!, height: 150, fit: BoxFit.fitWidth)))
    ]);
  }
}
