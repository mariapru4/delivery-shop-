import 'dart:async';

import 'package:delivery_app/providers/auth_provider.dart';
import 'package:delivery_app/providers/location_provider.dart';
import 'package:delivery_app/screens/add_new_product_screen.dart';
import 'package:delivery_app/screens/home_screen.dart';
import 'package:delivery_app/screens/login_screen.dart';
import 'package:delivery_app/screens/login_vendor_screen.dart';
import 'package:delivery_app/screens/main_screen.dart';
import 'package:delivery_app/screens/map_screen.dart';
import 'package:delivery_app/screens/register_screen.dart';
import 'package:delivery_app/screens/vendor_home_screen.dart';
import 'package:delivery_app/screens/welcome_screen.dart';
import 'package:delivery_app/widgets/image_picker.dart';
import 'package:delivery_app/widgets/reset_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => LocationPovider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primaryColor: Colors.deepOrangeAccent, fontFamily: 'Lato'),
      initialRoute: SplashScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        MapScreen.id: (context) => MapScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        ShopPicCard.id: (context) => ShopPicCard(),
        LoginVendorScreen.id: (context) => LoginVendorScreen(),
        ResetPasswordScreen.id: (context) => ResetPasswordScreen(),
        MainScreen.id: (context) => MainScreen(),
        VendorHomeScreen.id: (context) => VendorHomeScreen(),
        AddNewProduct.id: (context) => AddNewProduct(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => WelcomeScreen()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(tag: 'logo', child: Image.asset('images/logo.png')),
      ),
    );
  }
}
