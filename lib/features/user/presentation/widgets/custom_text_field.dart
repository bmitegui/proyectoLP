import 'package:flutter/material.dart';
import 'package:path_finder/core/theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String title;
  final String hintText;
  final TextEditingController textEditingController;
  final IconData iconData;
  final bool obscureText;
  final int maxLines;
  const CustomTextField(
      {super.key,
      required this.title,
      required this.hintText,
      required this.textEditingController,
      required this.iconData,
      this.obscureText = false,
      this.maxLines = 1});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(children: [
            Icon(widget.iconData, color: colorSeed),
            const SizedBox(width: 4),
            Text(widget.title,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold))
          ])),
      const SizedBox(height: 8),
      FocusScope(
          node: FocusScopeNode(),
          child: TextField(
              maxLines: widget.maxLines,
              obscureText: (widget.obscureText) ? _obscureText : false,
              autofocus: false,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              style: Theme.of(context).textTheme.bodyMedium,
              controller: widget.textEditingController,
              decoration: InputDecoration(
                  suffixIcon: (widget.obscureText)
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey))
                      : null,
                  contentPadding:
                      const EdgeInsets.only(left: 16, top: 32, right: 16),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.grey),
                  hintText: widget.hintText,
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)))))
    ]);
  }
}
