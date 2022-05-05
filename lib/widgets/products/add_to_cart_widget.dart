import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/widgets/cart/counter_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../services/cart_services.dart';

class AddToCart extends StatefulWidget {
  final DocumentSnapshot? document;
  AddToCart(this.document);
  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  CartServices _cart = CartServices();
  User? user = FirebaseAuth.instance.currentUser;
  bool _loading = false;
  bool _exist = false;
  int? _qty;
  String? _docId;
  @override
  void initState() {
    // getCarData(); //while opening product details screen/first will check this item
    //already in cart or not
    super.initState();
  }

  getCarData() async {
    final snapshot =
        await _cart.cart.doc(user!.uid).collection('products').get();
    if (snapshot.docs.length == 0) {
      //means this product not added to cart

      setState(() {
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //if this product exist in cart , we need to get qty details
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('products')
        .where('productId', isEqualTo: widget.document!['productId'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                if (doc['productId'] == widget.document!['productId']) {
                  //means selected product already exists in cart,so no need to add to cart again
                  setState(() {
                    _exist = true;
                    _qty = doc['qty'];
                    _docId = doc.id;
                  });
                }
              })
            });

    return _loading
        ? Container(
            height: 56,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
          )
        : _exist
            ? CounterWidget(
                document: widget.document,
                qty: _qty,
                docId: _docId,
              )
            : InkWell(
                onTap: () {
                  EasyLoading.show(status: 'Saving ...');
                  _cart.addToCart(widget.document).then((value) {
                    EasyLoading.showSuccess('Saved Successful');
                    Navigator.pop(context);
                  });
                },
                child: Container(
                  height: 56,
                  color: Colors.deepOrangeAccent,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_basket_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Add to Cart',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }
}
