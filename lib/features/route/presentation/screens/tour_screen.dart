import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_finder/core/theme/theme.dart';
import 'package:path_finder/core/utils/location_service.dart';
import 'package:path_finder/features/route/domain/entities/route.dart';
import 'package:path_finder/features/route/presentation/screens/end_tour_screen.dart';
import 'package:path_finder/features/route/presentation/screens/waiting_screen.dart';
import 'package:path_finder/main.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mtk;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

class TourScreen extends StatefulWidget {
  final RouteEntity routeEntity;
  const TourScreen({super.key, required this.routeEntity});

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> with WidgetsBindingObserver {
  LatLng? myPosition;
  LatLng? selectedPosition;
  StreamSubscription<Position>? _positionStream;
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  List<Marker> markerList = [];
  late Marker _destinationMarker;
  Marker? myLocationMarker;
  String _directions = '';
  String _distance = '';
  List<Polyline> myRouteList = [];
  int currentPlaceIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _destinationMarker = Marker(
        markerId: MarkerId(widget.routeEntity.name),
        position: LatLng(widget.routeEntity.stops[currentPlaceIndex].latitude, widget.routeEntity.stops[currentPlaceIndex].longitude),
      );
      markerList.add(_destinationMarker);
      setCustomIconForUserLocation();
      if (mounted) setState(() {});
      startListeningLocation();
    });
  }

void startListeningLocation() {
  _positionStream = Geolocator.getPositionStream(
    locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
  ).listen((Position position) {
    if (position != null) {
      setState(() {
        myPosition = LatLng(position.latitude, position.longitude);
        if (myLocationMarker == null) {
          if (markerIcon != BitmapDescriptor.defaultMarker) {
            myLocationMarker = Marker(
              markerId: MarkerId('currentLocation'),
              position: LatLng(position.latitude, position.longitude),
              icon: markerIcon,
              rotation: position.heading, // Rotación basada en la dirección del usuario
              zIndex: 2,
            );
            markerList.add(myLocationMarker!);
          }
        } else {
          myLocationMarker = myLocationMarker!.copyWith(
            positionParam: LatLng(position.latitude, position.longitude),
            rotationParam: position.heading,
          );
          markerList = markerList.map((marker) {
            if (marker.markerId.value == 'currentLocation') {
              return myLocationMarker!;
            } else {
              return marker;
            }
          }).toList();
        }
      });
      moveCameraToCurrentPosition();
      navigationProcess();
    }
  });
}


void moveCameraToCurrentPosition() async {
  final GoogleMapController controller = await _mapController.future;
  
  if (myPosition != null) {
    // Rotar la cámara según la dirección en la que el usuario esté mirando
    CameraPosition newCameraPosition = CameraPosition(
      target: myPosition!,
      zoom: 18,
      tilt: 40,
      bearing: myLocationMarker!.rotation,
    );

    controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }
}



  void setCustomIconForUserLocation() {
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  getBytesFromAsset('assets/img/user_location.png', 64).then((onValue) {
    setState(() {
      markerIcon = BitmapDescriptor.fromBytes(onValue);
    });
  }).catchError((error) {
    log("Error loading marker icon: $error");
  });
  }

  void navigationProcess() {
  List<mtk.LatLng> myLatLngList = [];
  for (var data in myRouteList.first.points) {
    myLatLngList.add(mtk.LatLng(data.latitude, data.longitude));
  }
  
  mtk.LatLng myPositionNavigation = mtk.LatLng(myPosition!.latitude, myPosition!.longitude);
  int x = mtk.PolygonUtil.locationIndexOnPath(myPositionNavigation , myLatLngList, true, tolerance: 12);
  
  if (x == -1) {
    getNewRouteFromAPI();
  } else {
    myLatLngList[x] = myPositionNavigation ;
    myLatLngList.removeRange(0, x);
    myRouteList.first.points.clear();
    myRouteList.first.points.addAll(myLatLngList.map((e) => LatLng(e.latitude, e.longitude)));

    // Update directions
    updateDirectionsBasedOnLocation(x);
  }
  
  if (mounted) setState(() {});

   _checkProximityToDestination();
 }

 void getNewRouteFromAPI() async {
  if (myRouteList.isNotEmpty) myRouteList.clear();

  log("GETTING NEW ROUTE !!");

  final origin = '${myPosition!.latitude},${myPosition!.longitude}';
  final destination = '${_destinationMarker.position.latitude},${_destinationMarker.position.longitude}';
  final apiKey = dotenv.env['GOOGLE_API_KEY'];

  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey&mode=walking&language=es'
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      final routeData = data['routes'][0];
      final legs = routeData['legs'][0];
      final polyline = routeData['overview_polyline']['points'];
      final duration = legs['duration']['text'];
      final distance = legs['distance']['text'];
      final steps = legs['steps']
          .map<String>((step) => _parseHtml(step['html_instructions'])) // Limpia las etiquetas HTML
          .toList();

      setState(() {
        myRouteList.add(Polyline(
          polylineId: PolylineId('route'),
          points: _decodePoly(polyline).map((e) => LatLng(e.latitude, e.longitude)).toList(),
          color: Color.fromARGB(255, 33, 155, 255),
          width: 5,
        ));
        _directions = steps.join('<br>'); // Guarda todas las instrucciones sin etiquetas HTML
        _distance = distance;
      });
    } else {
      log("Error in API response: ${data['status']}");
    }
  } else {
    log("Failed to load route");
  } 
 }

   List<mtk.LatLng> _decodePoly(String encoded) {
    List<mtk.LatLng> poly = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index) - 63;
        index++;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index) - 63;
        index++;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      poly.add(mtk.LatLng(
        (lat / 1E5),
        (lng / 1E5),
      ));
    }
    return poly;
  }

 String _parseHtml(String htmlString) {
  final document = html_parser.parse(htmlString);
  final String text = document.body?.text ?? "";
  return text;
 }

 void updateDirectionsBasedOnLocation(int index) {
  final steps = _directions.split('<br>');
  if (index < steps.length) {
    String rawHtml = steps[index];
    String formattedText = _parseHtml(rawHtml);
    setState(() {
      _directions = formattedText;
    });
  }
 }

 void _checkProximityToDestination() {
  if (myPosition == null) return;

  final destinationLatLng = LatLng(
    widget.routeEntity.stops[currentPlaceIndex].latitude,
    widget.routeEntity.stops[currentPlaceIndex].longitude,
  );

  final distanceInMeters = Geolocator.distanceBetween(
    myPosition!.latitude,
    myPosition!.longitude,
    destinationLatLng.latitude,
    destinationLatLng.longitude,
  );

  const double proximityThreshold = 20; // Distancia en metros para considerar "cerca" del destino

  if (distanceInMeters <= proximityThreshold) {
    _updateUIForProximity(); // Cambia la interfaz cuando el usuario esté cerca del destino
  }
 }

 void _updateUIForProximity() {
  currentPlaceIndex +=1;
  if(currentPlaceIndex<widget.routeEntity.stops.length){
  setState(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _destinationMarker = Marker(
        markerId: MarkerId(widget.routeEntity.name),
        position: LatLng(widget.routeEntity.stops[currentPlaceIndex].latitude, widget.routeEntity.stops[currentPlaceIndex].longitude),
      );
      markerList.add(_destinationMarker);
      setCustomIconForUserLocation();
      if (mounted) setState(() {});
      startListeningLocation();
    });
  });
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => WaitingScreen(),
    ),
  );
  }
  else {
     Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => EndTourScreen(),
    ),
  );

  }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: colorSeed,
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: Text(widget.routeEntity.name,
                maxLines: 2,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white)),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white))),
      body: myPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(children: [
            Positioned.fill(child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: selectedPosition ?? myPosition!,
                zoom: 18,
                tilt: 40, 
                bearing: 90, 
              ),
              onMapCreated: (GoogleMapController controller) {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }
              },
              polylines: Set<Polyline>.from(myRouteList),
              zoomControlsEnabled: false,
              markers: Set<Marker>.from(markerList),
              onTap: (LatLng point) {
                setState(() {
                  selectedPosition = point;
                });
              },
            ),
            ),
            Positioned(
            top: 10,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: teritoryColorDark,
                borderRadius: BorderRadius.only(topLeft: ui.Radius.circular(8), topRight: ui.Radius.circular(8)),
              ),
              child: Text( "Proxima parada: ${widget.routeEntity.stops[currentPlaceIndex].name}" ,style: TextStyle(color: Colors.white ,fontWeight: FontWeight.bold) ,
              ),
            ),
          ),
          Positioned(
            top: 45,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: teritoryColor_,
                borderRadius: BorderRadius.only(bottomLeft: ui.Radius.circular(8), bottomRight: ui.Radius.circular(8)),
              ),
              child: Row(
                children: [
                  // Direction arrow and distance
                  Column(
                    children: [
                      Icon(Icons.arrow_forward, size: 32, color: Colors.black),
                      Text(
                        _distance,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(color:Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  // Directions text
                  Expanded(
                    child: Text(
                      _directions,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
           Positioned(
            bottom: 30,
            left: 16,
            child: FloatingActionButton(
              onPressed: () {
                getNewRouteFromAPI();
              },
              child: Icon(Icons.directions, color: Colors.white),
            ),
          ),
          ]),
    );
  }
}
