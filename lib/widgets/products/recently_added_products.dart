import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/services/product_services.dart';
import 'package:delivery_app/widgets/products/product_card_widget.dart';
import 'package:flutter/material.dart';

class RecentlyAddedProducts extends StatelessWidget {
  const RecentlyAddedProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    return FutureBuilder<QuerySnapshot>(
      future: _services.products
          .where('published', isEqualTo: true)
          .where('collection', isEqualTo: 'Recently Added')
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        if (snapshot.data!.docs.isEmpty) {
          return Container();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: Colors.teal[100],
                      borderRadius: BorderRadius.circular(4)),
                  child: Center(
                    child: Text(
                      'Recently Added',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          shadows: <Shadow>[
                            Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Colors.black)
                          ]),
                    ),
                  ),
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return ProductCard(document);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
