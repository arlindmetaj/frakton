import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frakton_task/Constants/constants.dart';
import 'package:frakton_task/Screens/Authentication/login_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng SOURCE_LOCATION = LatLng(41.327953, 19.819025);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // var latitude = 0.0;
  // var longitude = 0.0;
  //
  // Future<Position?> determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   permission = await Geolocator.requestPermission();
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     Fluttertoast.showToast(
  //         msg: 'Si prega di abilitare il servizio di localizzazione');
  //   }
  //   permission = await Geolocator.checkPermission();
  //
  //   Position position = await Geolocator.getCurrentPosition(
  //       forceAndroidLocationManager: true,
  //       desiredAccuracy: LocationAccuracy.high);
  //
  //   longitude = position.longitude;
  //   latitude = position.latitude;
  //
  //   print(longitude);
  //   print(latitude);
  //   return null;
  // }

  final Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  Set<Marker> markers = <Marker>{};

  late LatLng currentLocation;

  @override
  void initState() {
    super.initState();
    setInitialLocation();
    setSourceMarkerIcon();
  }

  void setSourceMarkerIcon() {
    sourceIcon = BitmapDescriptor.defaultMarker;
  }

  void setInitialLocation() {
    currentLocation = LatLng(
      SOURCE_LOCATION.latitude,
      SOURCE_LOCATION.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPostion = const CameraPosition(
      zoom: Constants.CAMERA_ZOOM,
      tilt: Constants.CAMERA_TILT,
      bearing: Constants.CAMERA_BEARING,
      target: SOURCE_LOCATION,
    );

    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              myLocationEnabled: true,
              compassEnabled: false,
              tiltGesturesEnabled: false,
              markers: markers,
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPostion,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      )),
    );
  }

  Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}
