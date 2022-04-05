import 'dart:ui';

import 'package:delivery_app/providers/auth_provider.dart';
import 'package:delivery_app/screens/login_vendor_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const id = 'reset-password-screen';
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  String? email;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'images/forgot.png',
                  height: 300,
                  width: 300,
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                    text: TextSpan(text: '', children: [
                  TextSpan(
                      text: 'Forgot Password ?\n\n',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                  TextSpan(
                      text:
                          'Dont worry, Enter your registered Email, we will send you an email to reset your password \n',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ])),
                TextFormField(
                  controller: _emailTextController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Email';
                    }
                    final bool _isValid =
                        EmailValidator.validate(_emailTextController.text);
                    if (!_isValid) {
                      return 'Invalid Email Format';
                    }
                    setState(() {
                      email = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2)),
                      focusColor: Colors.deepOrangeAccent),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              _authData.resetPassword(email);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Please Check your Email for reset link')));
                            }
                            Navigator.pushReplacementNamed(
                                context, LoginVendorScreen.id);
                          },
                          color: Theme.of(context).primaryColor,
                          child: loading
                              ? LinearProgressIndicator()
                              : Text(
                                  'Reset Password',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
