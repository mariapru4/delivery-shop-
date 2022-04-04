import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/screens/home_screen.dart';
import 'package:delivery_app/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String smsOtp;
  late String verificationId;
  String error = '';
  UserServices _userServices = UserServices();
  bool loading = false;
  late File image;
  String pickerError = '';
  bool isPicAvail = false;
  String? email;
//reduce image size
  Future<File> getImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = 'No image selected';
      print('No image selected');
      notifyListeners();
    }
    return this.image;
  }

  Future<void> verifyPhone(
      {BuildContext? context,
      required String number,
      double? latitude,
      double? longitude,
      String? address}) async {
    this.loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      this.loading = false;
      print('e' + e.code);
      this.error = e.toString();
      notifyListeners();
    };
    final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {
      this.verificationId = verId;

      //open dialog to enter received OTP SMS
      smsOtpDialog(context!, number, latitude, longitude, address);
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
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
  }

  Future<bool> smsOtpDialog(BuildContext context, String number,
      double? latitude, double? longitude, String? address) async {
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
                      _createUser(
                          id: user!.uid,
                          number: user.phoneNumber,
                          latitude: null,
                          longitude: null,
                          address: null);
                      //navigate to Home page after login
                      if (user != null) {
                        Navigator.of(context).pop();

                        //dont want come back to welcome screen after logged in
                        Navigator.pushReplacementNamed(context, HomeScreen.id);
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

//register vendor using email
  Future<UserCredential> registerVendor(email, password) async {
    this.email = email;
    notifyListeners();
    late UserCredential userCredential;
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password provided is too weak.';
        notifyListeners();
      } else if (e.code == 'email-already-in-use') {
        this.error = 'The account already exists for that email.';
        notifyListeners();
        print('The account already exists for that email.');
      }
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  //save vendor data to firebase
  Future<void> saveVendorDataToDb(
      {String? url, String? shopName, String? mobile}) async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendors =
        FirebaseFirestore.instance.collection('vendors').doc(user!.uid);
    _vendors.set({
      'uid': user.uid,
      'shopNmae': shopName,
      'mobile': mobile,
      'email': this.email,
      'shopOpen': true,
      'rating': 0.00,
      'totalRating': 0,
      'isTopPicked': true,
      'imageUrl': url
    });
    return null;
  }

  void _createUser({
    String? id,
    String? number,
    double? latitude,
    double? longitude,
    String? address,
  }) {
    _userServices.createUser({
      'id': id,
      'number': number,
      'latitude': latitude,
      'longitude': longitude,
      'address': address
    });
  }

  void updateUser({
    String? id,
    String? number,
    double? latitude,
    double? longitude,
    String? address,
  }) {
    _userServices.updateUserData({
      'id': id,
      'number': number,
      'latitude': latitude,
      'longitude': longitude,
      'address': address
    });
  }
}
