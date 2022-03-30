import 'package:flutter/widgets.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPovider with ChangeNotifier {
  late double latitude;
  late double longitude;
  bool permissonAllowed = false;
  var selectedAddress;

  Future<void> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      this.latitude = position.latitude;
      this.longitude = position.longitude;
      this.permissonAllowed = true;
      notifyListeners();
    } else {
      print('Permission not allowed');
    }
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    this.latitude = cameraPosition.target.latitude;
    this.longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  // Future<void> getMoveCamera() async {
  //   final coordinates = new Coordinates(this.longitude);
  //   final address =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   this.selectedAddress = address.first;
  //   print("${selectedAddress.featureName} : ${selectedAddress.addressLine}");
  // }
}
