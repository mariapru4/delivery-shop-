import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/widgets/products/save_for_later.dart';
import 'package:flutter/material.dart';

import 'add_to_cart_widget.dart';

class BottomSheetContainer extends StatefulWidget {
  final DocumentSnapshot? document;
  BottomSheetContainer(this.document);

  @override
  _BottomSheetContainerState createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(flex: 1, child: SaveForLater(widget.document)),
          Flexible(flex: 1, child: AddToCart(widget.document))
        ],
      ),
    );
  }
}
