import 'package:delivery_app/main.dart';
import 'package:delivery_app/screens/register_screen.dart';
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
      body: Center(
        child: Column(
          children: [
            ImageSlider(),
            RaisedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                });
              },
              child: Text('Sign Out'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, WelcomeScreen.id);
              },
              child: Text('Home Screen'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, RegisterScreen.id);
              },
              child: Text('Add Shop'),
            ),
          ],
        ),
      ),
    );
  }
}
