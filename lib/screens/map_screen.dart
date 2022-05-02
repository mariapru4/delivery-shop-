import 'dart:async';

import 'dart:ui';

// import 'package:delivery_app/providers/location_provider.dart';
import 'package:delivery_app/providers/location_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData? _currentPosition;
  LatLng? _latLng;

  geocoding.Placemark? _placemark;
  bool _loading = false;
  bool _loggedIn = false;
  User? user;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    _getUserLocation();
    getCurrentUser();
    super.initState();
  }

  Future<LocationData> _getLocationPermission() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error('Service not enabled');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error('Permission Denied');
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  _getUserLocation() async {
    _currentPosition = await _getLocationPermission();

    _goToCurrentPosition(_latLng =
        LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!));
  }

  getUserAddress() async {
    List<geocoding.Placemark> placemarks = await geocoding
        .placemarkFromCoordinates(_latLng!.latitude, _latLng!.longitude);
    setState(() {
      _placemark = placemarks.first;
    });
  }

  getCurrentUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });

    if (user != null) {
      setState(() {
        _loggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationPovider>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  child: Stack(
                    children: [
                      GoogleMap(
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        mapType: MapType.terrain,
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        onCameraMove: (CameraPosition position) {
                          setState(() {
                            _latLng = position.target;
                            _loading = true;
                          });
                        },
                        onCameraIdle: () {
                          setState(() {
                            _loading = false;
                          });
                          getUserAddress();
                        },
                      ),
                      Align(
                        child: Icon(
                          Icons.location_on,
                          size: 40,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      _loading
                          ? LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            )
                          : SizedBox(
                              height: 5,
                            ),
                      _placemark != null
                          ? Column(
                              children: [
                                Text(
                                  _placemark!.street!,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    if (_placemark!.subLocality != null)
                                      Text('${_placemark!.subLocality!}'),
                                  ],
                                ),
                                Text('${_placemark!.locality!}'),
                                Text('${_placemark!.country!}')
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_loggedIn != false) {
                                    _auth.updateUser(
                                      id: user!.uid,
                                      number: user!.phoneNumber,
                                      latitude: _currentPosition!.latitude!,
                                      longitude: _currentPosition!.longitude!,
                                      address: _placemark!.street,
                                    );
                                  } else {
                                    final snackBar = SnackBar(
                                      content: const Text(
                                          'TO CONFIRM LOCATION FIRST LOGIN '),
                                      action: SnackBarAction(
                                        label: 'Login',
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, 'welcome-screen');
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.deepOrangeAccent),
                                ),
                                child: Text('Confirm Location')),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _goToCurrentPosition(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(latLng.latitude, latLng.longitude),
        // tilt: 59.440717697143555,
        zoom: 17.4746)));
  }
}
// late LatLng currentLocation;
// late GoogleMapController _mapController;
// @override
// Widget build(BuildContext context) {
//   final locationData = Provider.of<LocationPovider>(context);
//   setState(() {
//     currentLocation = LatLng(locationData.latitude, locationData.longitude);
//   });
//   void onCreated(GoogleMapController controller) {
//     setState(() {
//       _mapController = controller;
//     });
//   }
//
//   return Scaffold(
//     body: SafeArea(
//       child: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: currentLocation,
//               zoom: 14.4746,
//             ),
//             zoomControlsEnabled: false,
//             minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             mapType: MapType.normal,
//             mapToolbarEnabled: true,
//             onCameraMove: (CameraPosition position) {
//               locationData.onCameraMove(position);
//             },
//             onMapCreated: onCreated,
//             onCameraIdle: () {
//               // locationData.getMoveCamera();
//             },
//           ),
//           Center(
//               child: Container(
//                   height: 50,
//                   margin: EdgeInsets.only(bottom: 40),
//                   child: Image.asset('images/marker.png'))),
//           Positioned(
//             bottom: 0.0,
//             child: Container(
//               height: 200,
//               width: MediaQuery.of(context).size.width,
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   Text(''),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }
