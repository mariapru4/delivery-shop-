import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/screens/add_edit_coupon_screen.dart';
import 'package:delivery_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class CouponScreen extends StatelessWidget {
  static const id = 'coupon-screen';

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Scaffold(
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
        stream: _services.coupons
            .where('sellerId', isEqualTo: _services.user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text('No coupons added yet'),
            );
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.pushNamed(context, AddEditCoupon.id);
                        },
                        child: Text(
                          'Add New Coupon',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
              FittedBox(
                child: DataTable(columns: <DataColumn>[
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Rate')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Info')),
                  DataColumn(label: Text('Expiry')),
                ], rows: couponList(snapshot.data, context)),
              )
            ],
          );
        },
      )),
    );
  }

  List<DataRow> couponList(QuerySnapshot? snapshot, context) {
    List<DataRow> newList = snapshot!.docs.map((DocumentSnapshot document) {
      if (document != null) {
        var date = document['expiry'];
        var expiry = DateFormat.yMMMd().add_jm().format(date.toDate());
        return DataRow(
          cells: [
            DataCell(Text(document['title'])),
            DataCell(Text(document['discountRate'].toString())),
            DataCell(Text(document['active'] ? 'Active' : 'Inactive')),
            DataCell(Text(expiry.toString())),
            DataCell(IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddEditCoupon(document: document)));
                },
                icon: Icon(Icons.info_outline_rounded))),
          ],
        );
      }
    }).toList() as List<DataRow>;
    return newList;
  }
}
