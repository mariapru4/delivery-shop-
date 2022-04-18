import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/providers/product_provider.dart';
import 'package:delivery_app/services/firebase_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/vendor_banner_card.dart';

class VendorBannerScreen extends StatefulWidget {
  const VendorBannerScreen({Key? key}) : super(key: key);

  @override
  State<VendorBannerScreen> createState() => _VendorBannerScreenState();
}

class _VendorBannerScreenState extends State<VendorBannerScreen> {
  FirebaseServices _services = FirebaseServices();
  bool _visible = false;
  File? image;
  String pickerError = '';
  var _imagePathText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          VendorBannerCard(),
          Divider(
            thickness: 3,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              child: Center(
                  child: Text(
            'ADD NEW BANNER',
            style: TextStyle(fontWeight: FontWeight.bold),
          ))),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.grey[200],
                      child: image != null
                          ? Image.file(
                              image!,
                              fit: BoxFit.fill,
                            )
                          : Center(
                              child: Text('No Image Selected'),
                            ),
                    ),
                  ),
                  TextFormField(
                    controller: _imagePathText,
                    enabled: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: _visible ? false : true,
                    child: Row(
                      children: [
                        Expanded(
                            child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    _visible = true;
                                  });
                                },
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  'Add New Banner',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _visible,
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: FlatButton(
                                      onPressed: () {
                                        getBannerImage().then((value) {
                                          if (image != null) {
                                            setState(() {
                                              _imagePathText.text = image!.path;
                                            });
                                          }
                                        });
                                      },
                                      color: Theme.of(context).primaryColor,
                                      child: Text(
                                        'Upload Image',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ))),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: AbsorbPointer(
                                absorbing: image != null ? false : true,
                                child: FlatButton(
                                    onPressed: () {
                                      EasyLoading.show(status: 'Saving...');
                                      uploadBannerImage(
                                              image!.path, _provider.shopName)
                                          .then((url) {
                                        if (url != null) {
                                          //save banner url to firestore
                                          _services.saveBanner(url);
                                          setState(() {
                                            _imagePathText.clear();
                                            image = null;
                                          });
                                          EasyLoading.dismiss();
                                          _provider.alertDialog(
                                              context: context,
                                              title: 'Banner Upload',
                                              content:
                                                  'Banner Image Uploaded Successfully ');
                                        } else {
                                          EasyLoading.dismiss();
                                          _provider.alertDialog(
                                              context: context,
                                              title: 'Banner Upload',
                                              content: 'Banner Upload Failed');
                                        }
                                      });
                                    },
                                    color: image != null
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          _visible = false;
                                          _imagePathText.clear();
                                          image = null;
                                        });
                                      },
                                      color: Colors.black54,
                                      child: Text(
                                        'Cancle',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> uploadBannerImage(filePath, shopName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage.ref('vendorBanner/$shopName/$timeStamp').putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
    String downloadURL = await _storage
        .ref('vendorBanner/$shopName/$timeStamp')
        .getDownloadURL();

    return downloadURL;
  }

  Future<File?> getBannerImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    } else {
      this.pickerError = 'No image selected';
      print('No image selected');
    }
    return image;
  }
}
