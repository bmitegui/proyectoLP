import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_finder/core/theme/theme.dart';
import 'package:path_finder/core/utils/dialogs.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';
import 'package:path_finder/features/user/domain/entities/entities.dart';
import 'package:path_finder/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late User _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text('Perfil'),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
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
          if (state is UserAuthenticated) {
            _user = state.user;
          }
          return (state is UserAuthenticated)
              ? Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                                radius: 80.rf(context),
                                backgroundImage: const AssetImage(
                                    'assets/img/placeholder.jpg'))),
                        const SizedBox(height: 4),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                              '${state.user.firstName} ${state.user.lastName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 32),
                        Row(children: [
                          const Icon(Icons.email, color: teritoryColor_),
                          const SizedBox(width: 8),
                          Text('Correo:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Text(state.user.email)
                        ])
                      ]))
              : const Center(child: CircularProgressIndicator());
        }),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: CustomButtonWidget(
                onTap: () async {
                  await showWarningDialog(
                      context: context,
                      title: 'Cerrar sesión',
                      message: '¿Está seguro que desea cerrar sesión?',
                      onAccept: () {
                        context.read<UserBloc>().add(LogoutEvent(user: _user));
                      });
                },
                color: teritoryColor_,
                label: 'Cerrar sesión')));
  }
}
