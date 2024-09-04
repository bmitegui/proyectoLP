import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_finder/core/theme/app_theme.dart';
import 'package:path_finder/core/theme/responsive_size.dart';
import 'package:path_finder/core/utils/pick_image.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';

class PickImageWidget extends StatefulWidget {
  final String url;
  const PickImageWidget({super.key, required this.url});

  @override
  State<PickImageWidget> createState() => _PickImageWidgetState();
}

class _PickImageWidgetState extends State<PickImageWidget> {
  File? _fileImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  height: 200.rh(context),
                  width: double.infinity,
                  child: _fileImage != null
                      ? Image.file(_fileImage!, fit: BoxFit.cover)
                      : (widget.url != '')
                          ? Image.network(widget.url, fit: BoxFit.fitWidth)
                          : Image.asset('assets/img/placeholder.jpg',
                              fit: BoxFit.fitWidth)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                    child: CustomButtonWidget(
                        onTap: () async {
                          _fileImage = await pickImage(true);
                          if (_fileImage != null) {
                            setState(() {});
                          }
                        },
                        avaibleBorder: true,
                        iconData: Icons.camera_alt_sharp,
                        color: colorSeed,
                        label: 'Cámara',
                        isEnabled: true)),
                const SizedBox(width: 8),
                Expanded(
                    child: CustomButtonWidget(
                        onTap: () async {
                          _fileImage = await pickImage(false);
                          if (_fileImage != null) {
                            setState(() {});
                          }
                        },
                        avaibleBorder: true,
                        iconData: Icons.photo_sharp,
                        color: colorSeed,
                        label: 'Galería',
                        isEnabled: true))
              ]),
              const SizedBox(height: 32),
              Row(children: [
                if (widget.url != '')
                  Expanded(
                      child: CustomButtonWidget(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            Navigator.pop(context, ['eliminar']);
                          },
                          avaibleBorder: true,
                          color: Colors.red,
                          label: 'Eliminar',
                          isEnabled: true)),
                if (widget.url != '') const SizedBox(width: 8),
                Expanded(
                    child: CustomButtonWidget(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context, ['guardar', _fileImage]);
                        },
                        color: colorSeed,
                        label: 'Guardar',
                        isEnabled: _fileImage != null))
              ])
            ])));
  }
}
