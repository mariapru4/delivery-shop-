import 'dart:io';

import 'package:delivery_app/providers/auth_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _cPasswordTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _nameTextController = TextEditingController();
  String? email;
  String? address;
  String? password;
  String? mobile;
  String? shopName;
  bool _isLoding = false;
  scaffoldMessage(message) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Shop profile pic need to be added')));
  }

  Future<String> uploadFile(filePath) async {
    File file = File(filePath);

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage
          .ref('uploads/shopProfilePic/${_nameTextController.text}')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
    String downloadURL = await _storage
        .ref('uploads/shopProfilePic/${_nameTextController.text}')
        .getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return _isLoding
        ? CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        : Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Shop Name';
                      }
                      setState(() {
                        _nameTextController.text = value;
                      });
                      setState(() {
                        shopName = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.add_business),
                      labelText: 'Business Name',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Mobile Number';
                      }
                      setState(() {
                        mobile = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixText: '+91',
                      prefixIcon: Icon(Icons.phone_android),
                      labelText: 'Mobile Number',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
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
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: 'Business Name',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    keyboardType: TextInputType.streetAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Address';
                      }
                      setState(() {
                        address = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.add),
                      labelText: 'Address',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    controller: _passwordTextController,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Password';
                      }
                      setState(() {
                        password = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key_outlined),
                      labelText: 'Password',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Confirm Password';
                      }
                      // if (_passwordTextController.text !=
                      //     _cPasswordTextController.text) {
                      //   return 'Password doest match';
                      // }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key_outlined),
                      labelText: 'Confirm Password',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(3.0),
                //   child: TextFormField(
                //     maxLength: 6,
                //     controller: _addressTextController,
                //     validator: (value) {
                //       if (value!.isEmpty) {
                //         return 'Please press Navigator Button';
                //       }
                //       if (_authData.sh) return null;
                //     },
                //     decoration: InputDecoration(
                //       prefixIcon: Icon(Icons.contact_mail_outlined),
                //       labelText: 'Business Name',
                //       contentPadding: EdgeInsets.zero,
                //       suffix: IconButton(
                //         icon: Icon(Icons.location_searching),
                //         onPressed: () {
                //           _addressTextController.text =
                //               'Locating...\n Please wait...';
                //         },
                //       ),
                //       enabledBorder: OutlineInputBorder(),
                //       focusedBorder: OutlineInputBorder(
                //           borderSide: BorderSide(
                //               width: 2, color: Theme.of(context).primaryColor)),
                //       focusColor: Theme.of(context).primaryColor,
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(3.0),
                //   child: TextFormField(
                //     decoration: InputDecoration(
                //       prefixIcon: Icon(Icons.comment),
                //       labelText: 'Show Dialog',
                //       contentPadding: EdgeInsets.zero,
                //       enabledBorder: OutlineInputBorder(),
                //       focusedBorder: OutlineInputBorder(
                //           borderSide: BorderSide(
                //               width: 2, color: Theme.of(context).primaryColor)),
                //       focusColor: Theme.of(context).primaryColor,
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          if (_authData.isPicAvail == true) {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoding = true;
                              });
                              _authData
                                  .registerVendor(email, password)
                                  .then((credential) {
                                if (credential.user!.uid != null) {
                                  uploadFile(_authData.image.path).then((url) {
                                    if (url != null) {
                                      _authData
                                          .saveVendorDataToDb(
                                        url: url,
                                        mobile: mobile,
                                        shopName: shopName,
                                        address: address,
                                      )
                                          .then((value) {
                                        setState(() {
                                          _isLoding = false;
                                        });
                                        Navigator.pushReplacementNamed(
                                            context, HomeScreen.id);
                                      });
                                    }
                                  });
                                } else {
                                  scaffoldMessage(
                                      'Failed to upload Shop Profile');
                                }
                              });
                            } else {
                              scaffoldMessage(
                                  'Shop profile pic need to be added');
                            }
                          }
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
