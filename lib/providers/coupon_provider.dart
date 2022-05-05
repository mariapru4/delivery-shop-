import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CouponProvider with ChangeNotifier {
  bool? expired;
  DocumentSnapshot? doc;
  int discountRate = 0;

  Future<DocumentSnapshot> getCouponDetails(title, id) async {
    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('coupons').doc(title).get();

    if (document.exists) {
      if (document['sellerId'] == id) {
        checkExpiry(document);
      }
    }
    return document;
  }

  checkExpiry(DocumentSnapshot document) {
    DateTime date = document['expiry'].toDate();
    var dateDiff = date.difference(DateTime.now()).inDays;
    if (dateDiff < 0) {
      //coupon expired
      this.expired = true;
      notifyListeners();
    } else {
      this.doc = document;
      this.expired = false;
      this.discountRate = document['discountRate'];
      notifyListeners();
    }
  }
}
