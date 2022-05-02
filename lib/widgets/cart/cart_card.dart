import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'counter.dart';

class CartCard extends StatelessWidget {
  final DocumentSnapshot? document;
  CartCard({this.document});

  @override
  Widget build(BuildContext context) {
    double saving = document!['comparedPrice'] - document!['price'];
    return Container(
      height: 120,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      document!['productImage'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document!['productName']),
                      Text(
                        document!['weight'],
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      if (document!['comparedPrice'] > 0)
                        Text(
                          document!['comparedPrice'].toString(),
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12),
                        ),
                      Text(
                        document!['price'].toStringAsFixed(0),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              child: CounterForCard(document),
              right: 0.0,
              bottom: 0.0,
            ),
            if (saving > 0)
              Positioned(
                  child: CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '\$${saving.toStringAsFixed(0)}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ))
          ],
        ),
      ),
    );
  }
}
