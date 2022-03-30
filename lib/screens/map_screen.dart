import 'package:delivery_app/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationPovider>(context);
    return Scaffold(
      body: Center(
        child: Text(
            "LAT: ${locationData.latitude}, LNG: ${locationData.longitude}"),
      ),
    );
  }
}
