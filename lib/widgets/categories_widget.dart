import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/providers/store_provider.dart';
import 'package:delivery_app/screens/product_list_screen.dart';
import 'package:delivery_app/widgets/products/product_list.dart';
import 'package:delivery_app/services/product_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class VendorCategories extends StatefulWidget {
  const VendorCategories({Key? key}) : super(key: key);

  @override
  _VendorCategoriesState createState() => _VendorCategoriesState();
}

class _VendorCategoriesState extends State<VendorCategories> {
  ProductServices _services = ProductServices();
  List _catList = [];
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // add all this in a list
        setState(() {
          _catList.add(doc['category']['maincategory']);
        });
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);
    return FutureBuilder(
        future: _services.category.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went worng'),
            );
          }
          if (_catList.length == 0) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Container();
          }
          return SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return _catList.contains(document['name'])
                    ? InkWell(
                        onTap: () {
                          _storeProvider.selectedCategory(document['name']);
                          pushNewScreenWithRouteSettings(context,
                              screen: ProductListScreen(),
                              settings:
                                  RouteSettings(name:ProductListScreen.id
                                  ),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino);
                        },
                        child: Container(
                          width: 120,
                          height: 150,
                          child: Card(
                            child: Column(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: Center(
                                    child: Image.network(
                                      document['image'],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    document['name'],
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text('');
              }).toList(),
            ),
          );
        });
  }
}
