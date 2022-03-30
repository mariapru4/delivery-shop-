import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class LocationPovider with ChangeNotifier {
  double? latitude;
  double? longitude;
  bool permissonAllowed = false;

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
}
