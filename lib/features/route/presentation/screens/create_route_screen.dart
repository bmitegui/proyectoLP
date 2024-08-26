import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_finder/core/theme/theme.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';
import 'package:path_finder/features/route/presentation/widgets/step1_create_route_widget.dart';

class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({super.key});

  @override
  State<CreateRouteScreen> createState() => _CreateRouteState();
}

class _CreateRouteState extends State<CreateRouteScreen> {
  int _currentStep = 0;
  String routeNameInput = '';
  String routeDescriptionInput = '';
  DateTime routeDateInput = DateTime.now();
  int numberOfPeopleInput = 2;
  int numberOfGuidesInput = 1;
  double rangeAlertInput = 2;
  bool showPlaceInfoInput = false;
  String alertSoundInput = 'Sonido 1';
  bool publicRouteInput = false;
  // LatLng? meetingPointInput;
  // List<Place> stopsInput = [];
  // List<RouteType> routeTypesInput =
  //     []; // Lista para tipos de ruta seleccionados

  // late final RouteService routeService;

  // void createRoute() {
  //   // Aquí puedes procesar los datos capturados y crear la nueva ruta
  //   final TouristRoute newRoute = TouristRoute(
  //     name: routeNameInput,
  //     placesList: stopsInput,
  //     currentPlaceIndex: 0,
  //     numberPeople: numberOfPeopleInput,
  //     numberGuides: numberOfGuidesInput,
  //     routeIsPublic: publicRouteInput,
  //     routeDate: routeDateInput,
  //     startingPoint: meetingPointInput!,
  //     startTime:
  //         stopsInput.isNotEmpty ? stopsInput.first.startTime : TimeOfDay.now(),
  //     endTime:
  //         stopsInput.isNotEmpty ? stopsInput.last.endTime : TimeOfDay.now(),
  //     image: 'no_image',
  //     description: routeDescriptionInput,
  //     hasStarted: false,
  //     routeType: routeTypesInput, // Usar directamente la lista de RouteType
  //   );

  //   addPublicRoute(newRoute);

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("Ruta creada")),
  //   );
  //   Future.delayed(const Duration(seconds: 1), () {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (_) => const HomePage()),
  //     );
  //   });
  // }

  // Future<void> createRouteData(TouristRoute newRoute) async {
  //   routeService = await RouteService.create();
  //   await routeService.createData(newRoute);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: true,
            title: const Text('Crear una nueva ruta'),
            leading: IconButton(
                onPressed: () => GoRouter.of(context).go('/home'),
                icon: const Icon(Icons.arrow_back_ios))),
        body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Stepper(
                key: ValueKey<int>(_currentStep),
                currentStep: _currentStep,
                onStepContinue: () {
                  setState(() {
                    // if (_currentStep == 0 && routeNameInput.isEmpty) {
                    //   showSnackbar(
                    //     context,
                    //     "Debe ingresar el nombre de la ruta",
                    //     "error",
                    //   );
                    // } else if (_currentStep == 1 && stopsInput.isEmpty) {
                    //   showSnackbar(
                    //     context,
                    //     "Debe agregar al menos una parada",
                    //     "error",
                    //   );
                    // } else if (_currentStep == 2 && meetingPointInput == null) {
                    //   showSnackbar(
                    //     context,
                    //     "Debe seleccionar un punto de encuentro",
                    //     "error",
                    //   );
                    // } else if (_currentStep < 3) {
                    //   _currentStep++;
                    // } else {
                    //   createRoute();
                    // }
                  });
                },
                onStepCancel: () {
                  setState(() {
                    if (_currentStep > 0) {
                      _currentStep--;
                    }
                  });
                },
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  final isLastStep = _currentStep == 3;
                  final isFirstStep = _currentStep == 0;
                  return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!isFirstStep)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: details.onStepCancel,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(45, 75, 115, 1),
                                  ),
                                  child: const Text(
                                    'Atrás',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10),
                            if (isFirstStep)
                              SizedBox(
                                  width: 275.rw(context),
                                  child: CustomButtonWidget(
                                      onTap: () {
                                        details.onStepContinue!();
                                      },
                                      color: teritoryColor_,
                                      label: 'Siguiente'))
                            else
                              Expanded(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        // if (_currentStep == 1 && stopsInput.isEmpty) {
                                        //   showSnackbar(
                                        //     context,
                                        //     "Debe agregar al menos una parada",
                                        //     "error",
                                        //   );
                                        // } else if (_currentStep == 2 &&
                                        //     meetingPointInput == null) {
                                        //   showSnackbar(
                                        //     context,
                                        //     "Debe seleccionar un punto de encuentro",
                                        //     "error",
                                        //   );
                                        // } else {
                                        //   details.onStepContinue!();
                                        // }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            45, 75, 115, 1),
                                      ),
                                      child: Text(
                                          isLastStep
                                              ? 'Crear ruta'
                                              : 'Siguiente',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700))))
                          ]));
                },
                steps: [
                  Step(
                    title: const Text('Información Inicial'),
                    content: Step1CreateRouteWidget(),
                    isActive: _currentStep >= 0,
                  ),
                  Step(
                    title: const Text(
                      'Agregar Paradas',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    content: Container(),

                    //  RouteStep2(
                    //   stops: stopsInput,
                    //   onStopsChanged: (value) => setState(() {
                    //     stopsInput = value;
                    //   }),
                    // ),
                    isActive: _currentStep >= 1,
                  ),
                  Step(
                    title: const Text(
                      'Seleccionar Punto de Encuentro',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    content: Container(),
                    //  RouteStep3(
                    //   meetingPoint: meetingPointInput,
                    //   onMeetingPointChanged: (value) => setState(() {
                    //     meetingPointInput = value;
                    //   }),
                    // ),
                    isActive: _currentStep >= 2,
                  ),
                  Step(
                      title: const Text(
                        'Confirmación',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      content: Container(),
                      // RouteStep4(
                      //   routeName: routeNameInput,
                      //   routeDescription: routeDescriptionInput,
                      //   routeDate: routeDateInput,
                      //   numberOfPeople: numberOfPeopleInput,
                      //   numberOfGuides: numberOfGuidesInput,
                      //   rangeAlert: rangeAlertInput,
                      //   showPlaceInfo: showPlaceInfoInput,
                      //   alertSound: alertSoundInput,
                      //   publicRoute: publicRouteInput,
                      //   meetingPoint: meetingPointInput,
                      //   stops: stopsInput,
                      //   onConfirm: createRoute,
                      //   onCancel: () {
                      //     setState(() {
                      //       _currentStep = 0;
                      //     });
                      //   },
                      // ),
                      isActive: _currentStep >= 3)
                ])));
  }
}
