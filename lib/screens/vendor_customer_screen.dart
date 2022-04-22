import 'package:delivery_app/widgets/categories_widget.dart';
import 'package:delivery_app/widgets/image_slider.dart';
import 'package:delivery_app/widgets/products/best_selling_product.dart';
import 'package:delivery_app/widgets/products/featured_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/store_provider.dart';
import '../widgets/products/recently_added_products.dart';
import '../widgets/vendor/vendor_banner_slider.dart';

class VendorCustomerScreen extends StatelessWidget {
  static const String id = 'vendor-customer-screen';

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<StoreProvider>(context);
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext contxt, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: Colors.deepOrangeAccent,
            iconTheme: IconThemeData(color: Colors.white),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search))
            ],
            title: Text(
              _provider.selectedStore.toString(),
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          )
        ];
      },
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              VendorBannerSlider(),
              SizedBox(
                height: 10,
              ),
              VendorCategories(),
              //Recently Added Products
              //Best Selling Products
              //Featured Products
              FeaturedProducts(),
              BestSellingProducts(),
              RecentlyAddedProducts(),
            ],
          ),
        ),
      ),
    ));
  }
}
