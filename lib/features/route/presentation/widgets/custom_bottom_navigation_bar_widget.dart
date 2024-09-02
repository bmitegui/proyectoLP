import 'package:flutter/material.dart';
import 'package:path_finder/core/theme/theme.dart';
import 'package:path_finder/features/user/presentation/screens/perfil_screen.dart';

class CustomBottomNavigationBarWidget extends StatelessWidget {
  const CustomBottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      iconBottomNavigator(
          context: context, text: 'Mis Rutas', icon: Icons.gps_fixed),
      iconBottomNavigator(context: context, text: 'Home', icon: Icons.home),
      iconBottomNavigator(context: context, text: 'Perfil', icon: Icons.person)
    ]);
  }

  Widget iconBottomNavigator(
      {required BuildContext context,
      required String text,
      required IconData icon}) {
    return GestureDetector(
        onTap: () {
          if (text == 'Perfil') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PerfilScreen()));
          }
        },
        child: SizedBox(
            width: 70.rw(context),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.black),
                  const SizedBox(height: 4),
                  Text(text, style: Theme.of(context).textTheme.bodySmall)
                ])));
  }
}
