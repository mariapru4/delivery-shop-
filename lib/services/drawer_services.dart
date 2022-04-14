import 'package:delivery_app/screens/product_screen.dart';
import 'package:flutter/material.dart';

import '../screens/dashboard_screen.dart';

class DrawerServices {
  Widget drawerScreen(title) {
    if (title == 'Dashboard') {
      return VendorMainScreen();
    }
    if (title == 'Product') {
      return ProductScreen();
    }
    return VendorMainScreen();
  }
}
