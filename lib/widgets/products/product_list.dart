import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/services/product_services.dart';
import 'package:delivery_app/widgets/products/product_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/store_provider.dart';

class ProductListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _storeProvider = Provider.of<StoreProvider>(context);
    return FutureBuilder<QuerySnapshot>(
      future: _services.products
          .where('published', isEqualTo: true)
          .where('category.maincategory',
              isEqualTo: _storeProvider.selectedProductCategory)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Container();
        }

        return Column(
          children: [
            // Container(
            //   height: 50,
            //   color: Colors.grey,
            //   child: ListView(
            //     padding: EdgeInsets.zero,
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.only(right: 2, left: 6),
            //         child: Chip(
            //           label: Text('Sub Category'),
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(4)),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(right: 2, left: 6),
            //         child: Chip(
            //           label: Text('Sub Category'),
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(4)),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(right: 2, left: 6),
            //         child: Chip(
            //           label: Text('Sub Category'),
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(4)),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(right: 2, left: 6),
            //         child: Chip(
            //           label: Text('Sub Category'),
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(4)),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4)),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      '${snapshot.data!.docs.length} Items',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey[600]),
                    ),
                  ),
                ],
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
