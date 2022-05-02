import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  CollectionReference _vendorBanner =
      FirebaseFirestore.instance.collection('vendorbanner');
  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');

  getTopPickedStore() {
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .orderBy('shopNmae')
        .snapshots();
  }

  Future<DocumentSnapshot> getShopDetails(sellerUid) async {
    DocumentSnapshot snapshot = await vendors.doc(sellerUid).get();
    return snapshot;
  }
}
// this will show only verified vendor
// this will show only top picked vendor by admin
// this will sor the store alphabetic order
