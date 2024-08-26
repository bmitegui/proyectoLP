import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path_finder/core/theme/theme.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';

Future<void> showWarningDialog(
    {required BuildContext context,
    required String title,
    required String message,
    required Function() onAccept}) async {
  await AwesomeDialog(
          btnCancel: CustomButtonWidget(
              onTap: () {
                Navigator.pop(context);
              },
              avaibleBorder: true,
              color: Colors.red,
              label: 'No'),
          btnOk: CustomButtonWidget(
              onTap: () {
                Navigator.pop(context);
                onAccept();
              },
              avaibleBorder: false,
              color: teritoryColor_,
              label: 'Si'),
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.warning,
          title: title,
          desc: message,
          btnOkText: 'Si',
          btnCancelText: 'No')
      .show();
}
