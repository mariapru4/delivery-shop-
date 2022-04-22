import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/services/cart_services.dart';
import 'package:delivery_app/widgets/products/add_to_cart_widget.dart';
import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  final DocumentSnapshot? document;
  final String? docId;
  final int? qty;
  CounterWidget({this.document, this.qty, this.docId});

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int _qty;
  bool _updating = false;
  bool _exists = true;

  CartServices _cart = CartServices();
  @override
  Widget build(BuildContext context) {
    setState(() {
      _qty = widget.qty!;
    });
    return _exists
        ? Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            height: 56,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _updating = true;
                        });
                        if (_qty == 1) {
                          _cart.removeFromCart(widget.docId).then((value) {
                            setState(() {
                              _updating = false;
                              _exists = false;
                            });
                            //need ti check after remove if user have items in Cart
                            _cart.checkData();
                          });
                        }
                        if (_qty > 1) {
                          setState(() {
                            _qty--;
                          });
                          _cart.updateCartQty(widget.docId, _qty).then((value) {
                            setState(() {
                              _updating = false;
                            });
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red)),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                              _qty == 1 ? Icons.delete_outline : Icons.remove),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 8, bottom: 8),
                        child: _updating
                            ? Container(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                ),
                              )
                            : Text(_qty.toString()),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _updating = true;
                          _qty++;
                          _cart.updateCartQty(widget.docId, _qty).then((value) {
                            setState(() {
                              _updating = false;
                            });
                          });
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red)),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : AddToCart(widget.document);
  }
}
