// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_finder/core/theme/app_theme.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool permissionsGranted = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
          child: Image.asset('assets/img/background.png', fit: BoxFit.cover)),
      Positioned(
          right: -16, top: 64, child: Image.asset('assets/img/logo.png')),
      Positioned(
          left: 16,
          bottom: 16,
          right: 16,
          child: CustomButtonWidget(
              onTap: () async => await _requestPermissions(),
              color: colorSeed,
              label: 'Iniciar',
              isEnabled: true))
    ]);
  }

  Future<void> _requestPermissions() async {
    var locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('seen', true);
      permissionsGranted = true;
      GoRouter.of(context).go('/login');
    }else{
      return;
    }
  }
}
