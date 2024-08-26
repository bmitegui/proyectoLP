import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/core/theme/app_theme.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';
import 'package:path_finder/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:path_finder/features/user/presentation/widgets/custom_text_field.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _email;
  late TextEditingController _password;
  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late bool loginScreen;

  @override
  void initState() {
    super.initState();
    loginScreen = true;
    _email = TextEditingController();
    _password = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _lastName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 0, surfaceTintColor: scaffoldBackgroundColor),
        body: BlocConsumer<UserBloc, UserState>(
                listener: (BuildContext context, UserState state) {
              if (state is UserAuthenticated) {
                showTopSnackBar(
                    Overlay.of(context),
                    CustomSnackBar.success(
                        message: loginScreen
                            ? 'Acceso exitoso'
                            : 'Registro exitoso'));
              } else if (state is UserError) {
                showTopSnackBar(Overlay.of(context),
                    CustomSnackBar.error(message: state.message, maxLines: 3));
              }
            }, builder: (context, state) {
              return (state is UserUnauthenticated || state is UserError)
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                            if (MediaQuery.of(context).viewInsets.bottom == 0 &&
                                loginScreen)
                              Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Image.asset('assets/img/logo.png')),
                            if (MediaQuery.of(context).viewInsets.bottom == 0 &&
                                loginScreen)
                              const SizedBox(height: 64),
                            Text(
                                loginScreen
                                    ? 'Hola de nuevo!'
                                    : 'Creación de cuenta',
                                style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 16),
                            Text(
                                loginScreen
                                    ? 'Ingresa abajo para empezar a descubrir o crear nuevas rutas'
                                    : 'Completa los campos de abajo para poder crear tu cuenta',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall),
                            const SizedBox(height: 64),
                            CustomTextField(
                                title: 'Correo',
                                hintText: 'Ingrese su correo:',
                                textEditingController: _email,
                                iconData: Icons.email),
                            const SizedBox(height: 16),
                            CustomTextField(
                                title: 'Contraseña',
                                hintText: 'Ingrese su contraseña:',
                                textEditingController: _password,
                                iconData: Icons.password,
                                obscureText: true),
                            if (!loginScreen) const SizedBox(height: 16),
                            if (!loginScreen)
                              CustomTextField(
                                  title: 'Nombre',
                                  hintText: 'Ingrese su primer nombre:',
                                  textEditingController: _firstName,
                                  iconData: Icons.person),
                            if (!loginScreen) const SizedBox(height: 16),
                            if (!loginScreen)
                              CustomTextField(
                                  title: 'Apellido',
                                  hintText: 'Ingrese su primer apellido:',
                                  textEditingController: _lastName,
                                  iconData: Icons.person),
                            const SizedBox(height: 32),
                            SizedBox(
                                width: double.infinity,
                                child: CustomButtonWidget(
                                    onTap: () {
                                      if (!loginScreen) {
                                        context.read<UserBloc>().add(
                                            RegisterEvent(
                                                email: _email.text.trim(),
                                                password: _password.text.trim(),
                                                firstName:
                                                    _firstName.text.trim(),
                                                lastName:
                                                    _lastName.text.trim()));
                                      } else {
                                        context.read<UserBloc>().add(LoginEvent(
                                            email: _email.text.trim(),
                                            password: _password.text.trim()));
                                      }
                                    },
                                    color: colorSeed,
                                    label: loginScreen
                                        ? 'Ingresar'
                                        : 'Registrarse')),
                            const SizedBox(height: 32),
                            Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      loginScreen
                                          ? '¿Sin una cuenta aún?'
                                          : '¿Ya tienes una cuenta?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          loginScreen = !loginScreen;
                                        });
                                      },
                                      child: Text(
                                          loginScreen
                                              ? 'Regístrate ahora'
                                              : 'Ingresa ahora',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: colorSeed)))
                                ])
                          ])))
                  : const Center(child: CircularProgressIndicator());
            }));
  }
}
