import 'package:delivery_app/providers/auth_provider.dart';
import 'package:delivery_app/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

import 'map_screen.dart';
import 'onboard_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();
    return Scaffold(
      body: Container(
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
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  )),
              Text(
                'LOGIN',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    prefixText: '+91', labelText: '10 digit mobile number'),
                autofocus: true,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                onChanged: (value) {
                  if (value.length != 10) {
                    setState(() {
                      _validPhoneNumber = true;
                    });
                  } else {}
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  _validPhoneNumber
                                      ? 'CONTINUE'
                                      : 'ENTER PHONE NUMBER',
                                  style: TextStyle(color: Colors.black),
                                )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
