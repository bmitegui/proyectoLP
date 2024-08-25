import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_finder/core/theme/theme_config.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';
import 'package:path_finder/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Perfil'),
            leading: IconButton(
                onPressed: () => GoRouter.of(context).go('/home'),
                icon: const Icon(Icons.arrow_back_ios))),
        body: BlocConsumer<UserBloc, UserState>(
            listener: (BuildContext context, UserState state) {
          if (state is UserUnauthenticated) {
            showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.success(
                    message: 'Cierre de sesión exitoso'));
            GoRouter.of(context).go('/login');
          } else if (state is UserError) {
            showTopSnackBar(Overlay.of(context),
                CustomSnackBar.error(message: state.message, maxLines: 3));
          }
        }, builder: (context, state) {
          return (state is UserAuthenticated)
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    SizedBox(
                        width: double.infinity,
                        child: CustomButtonWidget(
                            onTap: () {
                              context
                                  .read<UserBloc>()
                                  .add(LogoutEvent(user: state.user));
                            },
                            color: teritoryColor_,
                            label: 'Cerrar sesion'))
                  ]))
              : const Center(child: CircularProgressIndicator());
        }));
  }
}
