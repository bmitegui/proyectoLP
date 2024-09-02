import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:path_finder/core/constants/environment.dart';
import 'package:path_finder/core/theme/app_theme.dart';
import 'package:path_finder/core/utils/location_service.dart';
import 'package:path_finder/core/widgets/custom_button_widget.dart';
import 'package:path_finder/features/route/domain/entities/entities.dart';
import 'package:path_finder/features/user/presentation/widgets/custom_text_field.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddUbiScreen extends StatefulWidget {
  final RouteEntity routeEntity;
  final bool agregarParada;
  const AddUbiScreen(
      {super.key, required this.routeEntity, required this.agregarParada});

  @override
  State<AddUbiScreen> createState() => _AddUbiScreenState();
}

class _AddUbiScreenState extends State<AddUbiScreen> {
  LatLng? myPosition;
  LatLng? selectedPosition;
  GoogleMapController? _mapController;
  late GoogleMapsPlaces _places;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  late TextEditingController _nameStop;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _initializePlaces();
    _nameStop = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameStop.dispose();
  }

  Future<void> _initializePlaces() async {
    final headers = await const GoogleApiHeaders().getHeaders();
    _places = GoogleMapsPlaces(
      apiKey: Environment.googleApiKey,
      apiHeaders: headers,
    );
  }

  Future<void> getCurrentLocation() async {
    final LatLng position = await LocationService.determinePosition();
    setState(() {
      myPosition = position;
      selectedPosition = myPosition;
    });
    _mapController?.moveCamera(CameraUpdate.newLatLng(myPosition!));
  }

  Future<void> _handleSearch() async {
    final Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Environment.googleApiKey,
      mode: Mode.overlay,
      language: 'es',
      components: [const Component(Component.country, 'ec')],
    );

    if (p != null) {
      _onPlaceSelected(p);
    }
  }

  Future<void> _onPlaceSelected(Prediction p) async {
    final PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    setState(() {
      selectedPosition = LatLng(lat, lng);
    });

    _mapController
        ?.animateCamera(CameraUpdate.newLatLngZoom(selectedPosition!, 14.0));
  }

  Future<void> selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: isStartTime
          ? 'Selecciona una hora para llegar a la parada'
          : 'Selecciona una hora para salir de la parada',
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          selectedStartTime = picked;
        } else {
          selectedEndTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: colorSeed,
            titleSpacing: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: Text(
                widget.agregarParada
                    ? 'Crear una parada'
                    : 'Crear punto de encuentro',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white)),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
            actions: [
              IconButton(
                  onPressed: _handleSearch,
                  icon: const Icon(Icons.search, color: Colors.white))
            ]),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: CustomButtonWidget(
                onTap: () {
                  if (!widget.agregarParada && selectedPosition != null) {
                    Navigator.pop(
                        context,
                        widget.routeEntity.copyWith(
                            latitude: selectedPosition!.latitude,
                            longitude: selectedPosition!.longitude));
                  } else if (selectedPosition == null) {
                    showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.info(
                            message: 'No ha seleccionado una posición'));
                  } else if (selectedStartTime == null) {
                    showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.info(
                            message: 'No ha seleccionado una hora de inicio'));
                  } else if (selectedEndTime == null) {
                    showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.info(
                            message: 'No ha seleccionado una hora de fin'));
                  } else if (selectedStartTime!.hour > selectedEndTime!.hour ||
                      (selectedStartTime!.hour == selectedEndTime!.hour &&
                          selectedStartTime!.minute >=
                              selectedEndTime!.minute)) {
                    showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.error(
                            message:
                                'La hora de inicio debe ser menor que la hora de fin'));
                  } else if (_nameStop.text.trim().isEmpty) {
                    showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.info(
                            message: 'Escriba el nombre de la parada'));
                  } else {
                    final now = DateTime.now();

                    final initialDate = DateTime(now.year, now.month, now.day,
                        selectedStartTime!.hour, selectedStartTime!.minute);

                    final endDate = DateTime(now.year, now.month, now.day,
                        selectedEndTime!.hour, selectedEndTime!.minute);
                    List<StopEntity> stops =
                        List.from(widget.routeEntity.stops);
                    stops.add(StopEntity(
                        name: _nameStop.text,
                        initialDate: initialDate,
                        endDate: endDate,
                        latitude: selectedPosition!.latitude,
                        longitude: selectedPosition!.longitude));
                    Navigator.pop(
                        context, widget.routeEntity.copyWith(stops: stops));
                  }
                },
                color: colorSeed,
                label: 'Crear parada')),
        body: myPosition == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(children: [
                  if (widget.agregarParada)
                    CustomTextField(
                        title: 'Nombre de la parada',
                        hintText: 'Ingrese el nombre de la parada',
                        textEditingController: _nameStop,
                        iconData: Icons.gps_fixed),
                  if (widget.agregarParada) const SizedBox(height: 16),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              border: Border.all(color: colorSeed),
                              borderRadius: BorderRadius.circular(20)),
                          child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                  target: selectedPosition ?? myPosition!,
                                  zoom: 14),
                              onMapCreated: (GoogleMapController controller) {
                                _mapController = controller;
                              },
                              markers: selectedPosition != null
                                  ? {
                                      Marker(
                                          markerId: const MarkerId(
                                              'selected-location'),
                                          position: selectedPosition!)
                                    }
                                  : {},
                              onTap: (LatLng point) {
                                setState(() {
                                  selectedPosition = point;
                                });
                              }))),
                  if (widget.agregarParada) const SizedBox(height: 16),
                  if (widget.agregarParada)
                    Row(children: [
                      Expanded(
                          child: CustomButtonWidget(
                              maxLines: 2,
                              avaibleBorder: true,
                              onTap: () async =>
                                  await selectTime(context, true),
                              color: colorSeed,
                              label: selectedStartTime == null
                                  ? 'Seleccionar Hora de Inicio'
                                  : 'Hora Inicio:\n${selectedStartTime!.format(context)}')),
                      const SizedBox(width: 8),
                      Expanded(
                          child: CustomButtonWidget(
                              maxLines: 2,
                              avaibleBorder: true,
                              onTap: () async =>
                                  await selectTime(context, false),
                              color: colorSeed,
                              label: selectedEndTime == null
                                  ? 'Seleccionar Hora de Fin'
                                  : 'Hora Fin:\n${selectedEndTime!.format(context)}'))
                    ])
                ])));
  }
}
