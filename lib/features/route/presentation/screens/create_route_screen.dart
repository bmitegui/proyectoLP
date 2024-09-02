import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/core/theme/theme.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';
import 'package:path_finder/features/route/presentation/bloc/routes/routes_bloc.dart';
import 'package:path_finder/features/route/presentation/widgets/step1_create_route_widget.dart';
import 'package:path_finder/features/route/presentation/widgets/step2_create_route_widget.dart';
import 'package:path_finder/features/route/presentation/widgets/step3_create_route_widget.dart';
import 'package:path_finder/features/route/presentation/widgets/step4_create_route_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({super.key});

  @override
  State<CreateRouteScreen> createState() => _CreateRouteState();
}

class _CreateRouteState extends State<CreateRouteScreen> {
  late int _currentStep;
  late RouteEntity _routeEntity;
  late TextEditingController _nameRoute;
  late TextEditingController _descriptionRoute;
  late File? _file;

  @override
  void initState() {
    super.initState();
    _file = null;
    _currentStep = 0;
    _nameRoute = TextEditingController();
    _descriptionRoute = TextEditingController();
    _routeEntity = RouteEntity(
        id: '',
        name: '',
        description: '',
        urlImage: '',
        peopleNumber: 1,
        guidesNumber: 1,
        alertRange: 1,
        showInfo: false,
        alertSound: 'Sonido 1',
        isPublic: false,
        initialDate: DateTime.now(),
        routeTypes: const [],
        stops: const [],
        latitude: 0,
        longitude: 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: colorSeed,
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: Text('Crear una nueva ruta',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white)),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white))),
        body: BlocConsumer<RoutesBloc, RoutesState>(
            listener: (BuildContext context, RoutesState state) {
          if (state is RoutesLoaded) {
            showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.success(
                    message: 'Ruta creada exitosamente'));
            Navigator.pop(context);
          }
        }, builder: (context, state) {
          return (state is RoutesLoaded)
              ? AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Stepper(
                      onStepTapped: (value) =>
                          setState(() => _currentStep = value),
                      key: ValueKey<int>(_currentStep),
                      currentStep: _currentStep,
                      onStepContinue: () => setState(() => _currentStep++),
                      onStepCancel: () => setState(() {
                            if (_currentStep > 0) {
                              _currentStep--;
                            }
                          }),
                      controlsBuilder:
                          (BuildContext context, ControlsDetails details) {
                        final isLastStep = _currentStep == 3;
                        final isFirstStep = _currentStep == 0;
                        return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child:
                                Row(mainAxisSize: MainAxisSize.max, children: [
                              if (!isFirstStep)
                                Expanded(
                                    child: CustomButtonWidget(
                                        onTap: () {
                                          details.onStepCancel!();
                                        },
                                        color: teritoryColor_,
                                        label: 'Atrás')),
                              if (!isFirstStep) const SizedBox(width: 8),
                              Expanded(
                                  child: CustomButtonWidget(
                                      onTap: () {
                                        if (isLastStep) {
                                          if (_canCreateARoute(
                                              context: context)) {
                                            _routeEntity =
                                                _routeEntity.copyWith(
                                                    name: _nameRoute.text,
                                                    description:
                                                        _descriptionRoute.text);
                                            context.read<RoutesBloc>().add(
                                                CreateRouteEvent(
                                                    listRoutes: state.routes,
                                                    routeEntity: _routeEntity,
                                                    file: _file!));
                                          }
                                        } else {
                                          details.onStepContinue!();
                                        }
                                      },
                                      color: teritoryColor_,
                                      label: isLastStep
                                          ? 'Crear ruta'
                                          : 'Siguiente'))
                            ]));
                      },
                      steps: [
                        Step(
                            title: Text('Información Inicial',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            content: Step1CreateRouteWidget(
                                route: _routeEntity,
                                file: _file,
                                nameRoute: _nameRoute,
                                descriptionRoute: _descriptionRoute,
                                onChange: (route) =>
                                    setState(() => _routeEntity = route),
                                onPickImage: (value) =>
                                    setState(() => _file = value)),
                            isActive: _currentStep >= 0),
                        Step(
                            title: Text('Agregar Paradas',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            content: Step2CreateRouteWidget(
                                routeEntity: _routeEntity,
                                onChange: (route) =>
                                    setState(() => _routeEntity = route)),
                            isActive: _currentStep >= 1),
                        Step(
                            title: Text('Seleccionar Punto de Encuentro',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            content: Step3CreateRouteWidget(
                                routeEntity: _routeEntity,
                                onChange: (route) =>
                                    setState(() => _routeEntity = route)),
                            isActive: _currentStep >= 2),
                        Step(
                            title: Text('Confirmación',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            content: Step4CreateRouteWidget(
                                name: _nameRoute.text,
                                description: _descriptionRoute.text,
                                routeEntity: _routeEntity,
                                file: _file),
                            isActive: _currentStep >= 3)
                      ]))
              : const Center(child: CircularProgressIndicator());
        }));
  }

  bool _canCreateARoute({required BuildContext context}) {
    if (_nameRoute.text.trim().isEmpty) {
      showTopSnackBar(Overlay.of(context),
          const CustomSnackBar.info(message: 'Por favor, ingrese un nombre'));
    } else if (_descriptionRoute.text.trim().isEmpty) {
      showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
              message: 'Por favor, ingrese una descripción'));
    } else if (_file == null) {
      showTopSnackBar(Overlay.of(context),
          const CustomSnackBar.info(message: 'Por favor, ingrese una imagen'));
    } else if (_routeEntity.routeTypes.isEmpty) {
      showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
              message: 'Por favor, escoja al menos un tipo de ruta'));
    } else if (_routeEntity.stops.isEmpty) {
      showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
              message: 'Por favor, ingrese al menos una parada'));
    } else if (_routeEntity.latitude == 0 && _routeEntity.longitude == 0) {
      showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
              message: 'Por favor, seleccione un punto de encuentro'));
    }

    return _nameRoute.text.trim().isNotEmpty &&
        _descriptionRoute.text.trim().isNotEmpty &&
        _file != null &&
        _routeEntity.routeTypes.isNotEmpty &&
        _routeEntity.stops.isNotEmpty &&
        _routeEntity.latitude != 0 &&
        _routeEntity.longitude != 0;
  }
}
