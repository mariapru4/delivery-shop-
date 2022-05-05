import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/providers/coupon_provider.dart';
import 'package:delivery_app/widgets/cart/coupon_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../services/store_service.dart';
import '../widgets/cart/cart_list.dart';

class CartScreen extends StatefulWidget {
  static const id = 'cart-screen';
  final DocumentSnapshot? document;
  CartScreen({this.document});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StoreServices _store = StoreServices();
  DocumentSnapshot? doc;
  var textStyle = TextStyle(color: Colors.grey);
  double discount = 0;
  int deliveryFee = 50;
  @override
  void initState() {
    _store.getShopDetails(widget.document!['sellerUid']).then((value) {
      setState(() {
        doc = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _cartProvider = Provider.of<CartProvider>(context);
    var _coupon = Provider.of<CouponProvider>(context);
    double subTotal = _cartProvider.subTotal;
    double discountRate = _coupon.discountRate / 100;
    setState(() {
      discount = subTotal * discountRate;
    });
    var _payable = _cartProvider.subTotal + deliveryFee - discount;

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
                        '\$${_payable.toStringAsFixed(0)}',
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
            headerSliverBuilder:
                (BuildContext context, bool innerBozIsSxrolled) {
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
                        'To Pay : ${_payable.toStringAsFixed(0)} ',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      )
                    ],
                  ),
                )
              ];
            },
            body: doc == null
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 56),
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        children: [
                          ListTile(
                            tileColor: Colors.white,
                            leading: Container(
                              height: 60,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  doc!['imageUrl'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(doc!['shopNmae']),
                            subtitle: Text(
                              doc!['address'],
                              maxLines: 1,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                          CartList(
                            document: widget.document,
                          ),

                          if (doc!.data() != null) CouponWidget(doc!['uid']),

                          //coupon

                          //bill details card
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bill Details',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'Basket value',
                                            style: textStyle,
                                          )),
                                          Text(
                                            '\$${_cartProvider.subTotal.toStringAsFixed(0)}',
                                            style: textStyle,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'Discount',
                                            style: textStyle,
                                          )),
                                          Text(
                                            '\$${discount.toStringAsFixed(0)}',
                                            style: textStyle,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'Delivery',
                                            style: textStyle,
                                          )),
                                          Text(
                                            '\$$deliveryFee',
                                            style: textStyle,
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'Total amount payable',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          Text(
                                            '\$${_payable.toStringAsFixed(0)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.3)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                'Total Saving',
                                                style: TextStyle(
                                                    color: Colors
                                                        .deepOrangeAccent),
                                              )),
                                              Text(
                                                '\$${_cartProvider.saving.toStringAsFixed(0)}',
                                                style: TextStyle(
                                                    color: Colors
                                                        .deepOrangeAccent),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )));
  }
}
