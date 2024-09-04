import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_finder/core/injection_container.dart';
import 'package:path_finder/core/theme/theme.dart';
import 'package:path_finder/core/utils/dialogs.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';
import 'package:path_finder/features/user/domain/entities/entities.dart';
import 'package:path_finder/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:path_finder/features/user/presentation/widgets/custom_text_field.dart';
import 'package:path_finder/features/user/presentation/widgets/pick_image_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late User _user;
  late TextEditingController _description;

  @override
  void initState() {
    _description = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

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
          } else if (state is UserAuthenticated) {
            if (state.message != null && _description.text.isEmpty) {
              showTopSnackBar(Overlay.of(context),
                  CustomSnackBar.success(message: state.message!));
            }
          }
        }, builder: (context, state) {
          if (state is UserAuthenticated && _description.text.isEmpty) {
            _description = TextEditingController(text: state.user.description);
          }
          return (state is UserAuthenticated)
              ? Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Container(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () async {
                                final List? lista =
                                    await showModalBottomSheet<List>(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return PickImageWidget(
                                              url: state.user.urlphoto);
                                        });

                                if (lista == null) {
                                  return;
                                }

                                if (lista[0] == 'guardar') {
                                  context.read<UserBloc>().add(
                                      UpdateProfileImageEvent(
                                          user: state.user, file: lista[1]));
                                } else {}
                              },
                              child: CircleAvatar(
                                  radius: 80.rf(context),
                                  foregroundImage:
                                      NetworkImage(state.user.urlphoto),
                                  backgroundImage: const AssetImage(
                                      'assets/img/placeholder.jpg')),
                            )),
                        const SizedBox(height: 4),
                        Container(
                            alignment: Alignment.center,
                            child: Text(
                                '${state.user.firstName} ${state.user.lastName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold))),
                        const SizedBox(height: 32),
                        CustomTextField(
                            title: 'Acerca de mi:',
                            hintText: 'Habla sobre mi:',
                            textEditingController: _description!,
                            maxLines: 4,
                            iconData: Icons.person),
                        if (state.user.description != _description!.text)
                          CustomButtonWidget(
                              onTap: () {
                                context.read<UserBloc>().add(
                                    UpdateDescriptionEvent(
                                        user: state.user,
                                        description: _description!.text));
                              },
                              color: colorSeed,
                              avaibleBorder: true,
                              label: 'Guardar descripción'),
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
                        ]),
                        const SizedBox(height: 16),
                        Row(children: [
                          const Icon(Icons.map, color: teritoryColor_),
                          const SizedBox(width: 8),
                          Text('Rutas:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Text('${state.user.rutas}')
                        ])
                      ])))
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
