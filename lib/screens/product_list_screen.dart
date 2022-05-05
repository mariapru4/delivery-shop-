import 'package:delivery_app/widgets/products/product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/store_provider.dart';

class ProductListScreen extends StatelessWidget {
  static const String id = 'product-list-screen';

  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.deepOrangeAccent,
              title: Text(
                _store.selectedProductCategory.toString(),
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: IconThemeData(color: Colors.white),
            )
          ];
        },
        body: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [ProductListWidget()],
        ),
      ),
    );
  }
}
