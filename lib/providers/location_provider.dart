import 'package:flutter/widgets.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPovider with ChangeNotifier {
  late double latitude;
  late double longitude;
  bool permissonAllowed = false;
  var selectedAddress;
  // late geocoding.Placemark _placemark;

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

  // getUserAddress() async {
  //   List<geocoding.Placemark> placemarks =
  //       await geocoding.placemarkFromCoordinates(latitude, longitude);
  //
  //   _placemark = placemarks.first;
  // }

  // Future<void> savePrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setDouble('latitude', this.latitude);
  //   prefs.setDouble('longitude', this.longitude);
  //   prefs.setString('address', this._placemark.street.toString());
  //   prefs.setString('location', this._placemark.country.toString());
  // }
}
