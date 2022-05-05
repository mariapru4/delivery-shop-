import 'package:delivery_app/screens/add_edit_coupon_screen.dart';
import 'package:delivery_app/screens/coupon_screen.dart';
import 'package:delivery_app/screens/product_screen.dart';
import 'package:flutter/material.dart';

import '../screens/dashboard_screen.dart';
import '../screens/vendor_banner_screen.dart';

class DrawerServices {
  Widget drawerScreen(title) {
    if (title == 'Dashboard') {
      return VendorMainScreen();
    }
    if (title == 'Product') {
      return ProductScreen();
    }
    if (title == 'Banner') {
      return VendorBannerScreen();
    }
    if (title == 'Coupons') {
      return CouponScreen();
    }
    return VendorMainScreen();
  }
}
