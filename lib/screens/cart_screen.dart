import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  static const id = 'cart-screen';
  final DocumentSnapshot? document;
  CartScreen({this.document});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    var _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
        bottomSheet: Container(
          height: 60,
          color: Colors.blueGrey[900],
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${_cartProvider.subTotal.toStringAsFixed(0)}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Including Taxes',
                        style: TextStyle(color: Colors.green, fontSize: 10),
                      )
                    ],
                  ),
                  RaisedButton(
                    onPressed: () {},
                    color: Colors.redAccent,
                    child: Text(
                      'CHECKOUT',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBozIsSxrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Colors.deepOrangeAccent,
                elevation: 0.0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.document!['shopName'],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      '${_cartProvider.cartQty} ${_cartProvider.cartQty > 1 ? 'Items,' : 'Item'}',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Text(
                      'To Pay : ${_cartProvider.subTotal.toStringAsFixed(0)} ',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    )
                  ],
                ),
              )
            ];
          },
          body: Center(
            child: Text('Cart Screen'),
          ),
        ));
  }
}
