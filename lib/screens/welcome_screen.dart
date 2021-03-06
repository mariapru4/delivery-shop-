// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:delivery_app/providers/auth_provider.dart';
import 'package:delivery_app/providers/location_provider.dart';
import 'package:delivery_app/screens/login_screen.dart';
import 'package:delivery_app/screens/login_vendor_screen.dart';
import 'package:delivery_app/screens/map_screen.dart';
import 'package:delivery_app/screens/onboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome-screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();
    void showBottonSheet(context) {
      showModalBottomSheet(
          context: context,
          builder: (context) =>
              StatefulBuilder(builder: (context, StateSetter myState) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: auth.error == 'Invalid OTP' ? true : false,
                            child: Container(
                              child: Column(
                                children: [
                                  Text(
                                    auth.error,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                            )),
                        Text(
                          'LOGIN',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Enter your phone number to proceed',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              prefixText: '+91',
                              labelText: '10 digit mobile number'),
                          autofocus: true,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          onChanged: (value) {
                            if (value.length == 10) {
                              myState(() {
                                _validPhoneNumber = true;
                              });
                            } else {
                              myState(() {
                                _validPhoneNumber = false;
                              });
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AbsorbPointer(
                                absorbing: _validPhoneNumber ? false : true,
                                child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    onPressed: () {
                                      setState(() {
                                        auth.loading = true;
                                      });

                                      String number = '+917999999999';
                                      print(number);
                                      auth.verifyPhone(
                                          context: context,
                                          number: number,
                                          latitude: null,
                                          longitude: null,
                                          address: null);
                                      auth.loading = false;
                                    },
                                    color: _validPhoneNumber
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                    child: auth.loading
                                        ? CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          )
                                        : Text(
                                            _validPhoneNumber
                                                ? 'CONTINUE'
                                                : 'ENTER PHONE NUMBER',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }));
    }

    final locationData = Provider.of<LocationPovider>(context, listen: false);

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Column(children: [
                Expanded(child: OnBaordScreen()),
                Text(
                  'Ready to order from your nearest branch?',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  color: Colors.deepOrangeAccent,
                  onPressed: () async {
                    await locationData.getCurrentPosition();
                    if (locationData.permissonAllowed == true) {
                      Navigator.pushReplacementNamed(context, MapScreen.id);
                    } else {
                      print('error');
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    'Set Delivery Location',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                FlatButton(
                    color: Colors.deepOrangeAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, LoginVendorScreen.id);
                    },
                    child:
                        Text('Vendor', style: TextStyle(color: Colors.white))),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  child: RichText(
                    text: const TextSpan(
                      text: 'Already have an  Account?  ',
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                            text: 'Customer Login ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                  onPressed: () {
                    showBottonSheet(context);
                  },
                ),
              ]),
            ],
          )),
    );
  }
}
