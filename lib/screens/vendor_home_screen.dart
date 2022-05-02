import 'package:delivery_app/screens/dashboard_screen.dart';
import 'package:delivery_app/services/drawer_services.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import '../widgets/drawer_menu_widget.dart';

class VendorHomeScreen extends StatefulWidget {
  static const String id = 'vendor-home-screen';

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  DrawerServices _services = DrawerServices();
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();

  String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderMenuContainer(
          appBarColor: Colors.white,
          appBarHeight: 80,
          key: _key,
          sliderMenuOpenSize: 250,
          title: Text(
            '',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          trailing: Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search)),
              IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.bell))
            ],
          ),
          sliderMenu: MenuWidget(
            onItemClick: (title) {
              _key.currentState!.closeDrawer();
              setState(() {
                this.title = title;
              });
            },
          ),
          sliderMain: _services.drawerScreen(title)),
    );
  }
}
