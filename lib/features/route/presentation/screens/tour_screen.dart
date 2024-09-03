import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_finder/core/utils/location_service.dart';
import 'package:path_finder/features/route/domain/entities/route.dart';
import 'package:path_finder/main.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _destinationMarker = Marker(
        markerId: MarkerId(widget.routeEntity.name),
        position: LatLng(widget.routeEntity.stops[0].latitude, widget.routeEntity.stops[0].longitude),
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
                rotation: position.heading,
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
      }
    });
  }

  void moveCameraToCurrentPosition() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(LatLng(myPosition!.latitude, myPosition!.longitude)),
    );
  }

  void setCustomIconForUserLocation() {
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }

  getBytesFromAsset('assets/img/user_location.png', 64).then((onValue) {
    setState(() {
      markerIcon = BitmapDescriptor.fromBytes(onValue);
    });
  }).catchError((error) {
    log("Error loading marker icon: $error");
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routeEntity.name, textAlign: TextAlign.start),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: myPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: selectedPosition ?? myPosition!,
                zoom: 14,
              ),
              onMapCreated: (GoogleMapController controller) {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }
              },
              markers: Set<Marker>.from(markerList),
              onTap: (LatLng point) {
                setState(() {
                  selectedPosition = point;
                });
              },
            ),
    );
  }
}
