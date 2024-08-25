import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_finder/core/theme/theme.dart';
import 'package:path_finder/features/user/presentation/screens/perfil_screen.dart';

class CustomBottomNavigationBarWidget extends StatefulWidget {
  final String page;
  const CustomBottomNavigationBarWidget({super.key, required this.page});

  @override
  State<CustomBottomNavigationBarWidget> createState() =>
      _CustomBottomNavigationBarWidgetState();
}

class _CustomBottomNavigationBarWidgetState
    extends State<CustomBottomNavigationBarWidget> {
  late String textSelected;
  @override
  void initState() {
    super.initState();
    textSelected = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      iconBottomNavigator(text: 'Mis Rutas', icon: Icons.gps_fixed),
      iconBottomNavigator(text: 'Home', icon: Icons.home),
      iconBottomNavigator(text: 'Perfil', icon: Icons.person)
    ]);
  }

  Widget iconBottomNavigator({required String text, required IconData icon}) {
    return GestureDetector(
        onTap: () => setState(() {
              textSelected = text;
              if (text == 'Perfil') {
                GoRouter.of(context).go('/perfil');
              }
            }),
        child: SizedBox(
            width: 70.rw(context),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon,
                      color: text == textSelected
                          ? teritoryColorDark
                          : Colors.black),
                  const SizedBox(height: 4),
                  Text(text, style: Theme.of(context).textTheme.bodySmall)
                ])));
  }
}
