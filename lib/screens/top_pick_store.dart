import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/providers/store_provider.dart';
import 'package:delivery_app/screens/vendor_customer_screen.dart';

import 'package:delivery_app/services/store_service.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class TopPickStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StoreServices _storeServices = StoreServices();
    var _provider = Provider.of<StoreProvider>(context);
    return Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: _storeServices.getTopPickedStore(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              return Column(
                children: [
                  Flexible(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        return InkWell(
                          onTap: () {
                            _provider.getSelectedStore(
                                document['shopNmae'], document['uid']);

                            pushNewScreenWithRouteSettings(context,
                                screen: VendorCustomerScreen(),
                                settings: RouteSettings(
                                    name: VendorCustomerScreen.id),
                                withNavBar: true,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        20), // Image border
                                    child: SizedBox.fromSize(
                                      size: Size.fromRadius(48), // Image radius
                                      child: Image.network(document['imageUrl'],
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Center(
                                    child: Container(
                                      height: 35,
                                      child: Text(
                                        document['shopNmae'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              );
            }));
  }
}
