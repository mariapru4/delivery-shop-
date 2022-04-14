import 'package:delivery_app/providers/auth_provider.dart';
import 'package:delivery_app/screens/home_screen.dart';
import 'package:delivery_app/screens/register_screen.dart';
import 'package:delivery_app/screens/vendor_home_screen.dart';
import 'package:delivery_app/widgets/reset_password.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginVendorScreen extends StatefulWidget {
  static const id = 'login-vendor-screen';

  @override
  _LoginVendorScreenState createState() => _LoginVendorScreenState();
}

class _LoginVendorScreenState extends State<LoginVendorScreen> {
  final _formKey = GlobalKey<FormState>();
  Icon? icon;
  bool _visible = false;
  var _emailTextController = TextEditingController();
  String? email;
  String? password;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'LOGIN',
                          style: TextStyle(fontFamily: 'Anton', fontSize: 30),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          'images/logo.png',
                          height: 80,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                                  color: Theme.of(context).primaryColor,
                                  width: 2)),
                          focusColor: Colors.deepOrangeAccent),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Password';
                        }
                        if (value.length < 6) {
                          return 'Minimum 6 characters';
                        }
                        setState(() {
                          password = value;
                        });
                        return null;
                      },
                      obscureText: _visible == false ? true : false,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: _visible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _visible = !_visible;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2)),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, ResetPasswordScreen.id);
                          },
                          child: Expanded(
                            child: Text(
                              'Forgot Password ?',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
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
                                _authData
                                    .loginVendor(email, password)
                                    .then((credential) {
                                  if (credential.user!.uid != null) {
                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.pushReplacementNamed(
                                        context, VendorHomeScreen.id);
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(_authData.error),
                                    ));
                                  }
                                });
                              }
                            },
                            child: loading
                                ? LinearProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    backgroundColor: Colors.transparent,
                                  )
                                : Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    FlatButton(
                      child: RichText(
                        text: const TextSpan(
                          text: "Don't Have An Account?",
                          style: TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                                text: ' Register',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, RegisterScreen.id);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
