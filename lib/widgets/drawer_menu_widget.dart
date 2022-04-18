import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/providers/product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuWidget extends StatefulWidget {
  final Function(String)? onItemClick;

  const MenuWidget({Key? key, this.onItemClick}) : super(key: key);

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  var vendorData;

  @override
  void initState() {
    getVendors();
    super.initState();
  }

  Future<DocumentSnapshot> getVendors() async {
    var result = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(user!.uid)
        .get();
    setState(() {
      vendorData = result;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    _provider.getShopName(vendorData != null ? vendorData['shopNmae'] : '');
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: vendorData != null
                  ? NetworkImage(vendorData['imageUrl'])
                  : null,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            vendorData != null ? vendorData['shopNmae'] : 'Shop Name',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          sliderItem('Dashboard', Icons.dashboard_outlined),
          sliderItem('Product', Icons.add_circle),
          sliderItem('Coupons', CupertinoIcons.gift),
          sliderItem('Orders', Icons.list_alt_outlined),
          sliderItem('Banner', CupertinoIcons.photo),
          sliderItem('Setting', Icons.settings),
          sliderItem('LogOut', Icons.exit_to_app_outlined)
        ],
      ),
    );
  }

  Widget sliderItem(String title, IconData icons) => ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      leading: Icon(
        icons,
        color: Colors.black,
      ),
      onTap: () {
        widget.onItemClick!(title);
      });
}
