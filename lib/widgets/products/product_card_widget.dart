import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/screens/product_details_screen.dart';
import 'package:delivery_app/widgets/cart/counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProductCard extends StatelessWidget {
  final DocumentSnapshot document;
  ProductCard(this.document);

  @override
  Widget build(BuildContext context) {
    String offer = ((document['comparedPrice'] - document['price']) /
            document['comparedPrice'] *
            100)
        .toStringAsFixed(0);
    return Container(
      height: 160,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
      child: Padding(
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
        child: Row(
          children: [
            Stack(
              children: [
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      pushNewScreenWithRouteSettings(context,
                          screen: ProductDetailsScreen(
                            document: document,
                          ),
                          settings:
                              RouteSettings(name: ProductDetailsScreen.id),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino);
                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(document['productImage']),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      '$offer %OFF',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(document['productName']),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 160,
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey[200]),
                    child: Text(
                      document['weight'],
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Text(
                        '\$${document['price'].toStringAsFixed(0)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        '\$${document['comparedPrice'].toString()}',
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 12),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width - 160,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CounterForCard(document),
                              ),
                            ],
                          ))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
