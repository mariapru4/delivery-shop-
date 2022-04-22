import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:delivery_app/widgets/products/bottom_sheet.dart';
import 'package:expandable_text/expandable_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String id = 'product-details-screen';
  final DocumentSnapshot? document;
  ProductDetailsScreen({this.document});

  @override
  Widget build(BuildContext context) {
    String offer = ((document!['comparedPrice'] - document!['price']) /
            document!['comparedPrice'] *
            100)
        .toStringAsFixed(0);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search))
          ],
        ),
        bottomSheet: BottomSheetContainer(document),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(
                children: [
                  Container(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, bottom: 2, top: 2),
                    ),
                  ),
                ],
              ),
              Text(
                document!['productName'],
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: 10,
              ),
              Text(document!['weight'], style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    '\$${document!['price'].toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '\$${document!['comparedPrice'].toStringAsFixed(0)}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(2)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 3, bottom: 3),
                      child: Text(
                        '$offer% OFF',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12),
                      ),
                    ),
                  )
                ],
              ),
              Image.network(document!['productImage']),
              Divider(
                color: Colors.grey,
                thickness: 6,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    'About this product :',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: ExpandableText(
                  document!['description'],
                  expandText: 'View more',
                  collapseText: 'View less',
                  maxLines: 2,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Column(
                children: [
                  Text(
                    'SKU: ${document!['sku']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Seller: ${document!['seller']['shopName']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
