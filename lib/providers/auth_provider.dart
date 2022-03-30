import 'dart:ui';

import 'package:delivery_app/screens/home_screen.dart';
import 'package:delivery_app/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String smsOtp;
  late String verificationId;
  String error = '';
  UserServices _userServices = UserServices();

  Future<void> verifyPhone(BuildContext context, String number) async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      print('e' + e.code);
    };
    final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {
      this.verificationId = verId;

      //open dialog to enter received OTP SMS
      smsOtpDialog(context, number);
    };
    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSend,
        codeAutoRetrievalTimeout: (String verId) {
          this.verificationId = verId;
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<bool> smsOtpDialog(BuildContext context, String number) async {
    bool goBack = false;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text('Verification Code'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Enter 6 digit OTP receiced as SMS',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              FlatButton(
                  onPressed: () async {
                    goBack = false;

                    try {
                      PhoneAuthCredential phoneAuthCredential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: smsOtp);
                      final User? user = (await _auth
                              .signInWithCredential(phoneAuthCredential))
                          .user;
                      //create user data in firestore after user successfully registered
                      _createUser(id: user!.uid, number: user.phoneNumber);
                      //navigate to Home page after login
                      if (user != null) {
                        Navigator.of(context).pop();

                        //dont want come back to welcome screen after logged in
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ));
                      } else {
                        print('login Failed');
                      }
                    } catch (e) {
                      this.error = 'Invalid OTP';
                      notifyListeners();
                      print(e.toString());
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('DONE'))
            ],
          );
        });
    return goBack;
  }

  void _createUser({String? id, String? number}) {
    _userServices.createUser({'id': id, 'number': number});
  }
}
