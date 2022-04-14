import 'package:flutter/material.dart';

class VendorMainScreen extends StatefulWidget {
  const VendorMainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<VendorMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Dashboard Screen'),
    );
  }
}
