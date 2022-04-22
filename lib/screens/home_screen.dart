import 'package:delivery_app/main.dart';
import 'package:delivery_app/screens/main_screen.dart';
import 'package:delivery_app/screens/register_screen.dart';
import 'package:delivery_app/screens/top_pick_store.dart';

import 'package:delivery_app/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/image_slider.dart';
import '../widgets/my_appbar.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _location;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(112),
        child: MyAppBar(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepOrangeAccent,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: 'Favorite',
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              ImageSlider(),
              SizedBox(
                height: 15,
              ),
              Container(height: 300, child: TopPickStore()),
            ],
          ),
        ),
      ),
    );
  }
}
