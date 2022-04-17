import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/providers/product_provider.dart';
import 'package:delivery_app/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../widgets/category_list.dart';

class EditViewProduct extends StatefulWidget {
  final String? productId;

  EditViewProduct({this.productId});

  @override
  _EditViewProductState createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  var _skuText = TextEditingController();
  var _productNameText = TextEditingController();
  var _weightText = TextEditingController();
  var _priceText = TextEditingController();
  var _comapredPriceText = TextEditingController();
  var _descriptionText = TextEditingController();
  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _stockTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();

  List<String> _collections = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];
  String? dropdownValue;

  String? image;
  String? categoryImage;
  File? _image;
  bool _visible = false;
  bool _editing = true;

  DocumentSnapshot? doc;
  double? discount;

  @override
  void initState() {
    getProductsDetails();
    super.initState();
  }

  Future<void> getProductsDetails() async {
    _services.products
        .doc(widget.productId)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        setState(() {
          doc = document;
          _skuText.text = document['sku'];
          _productNameText.text = document['productName'];
          _weightText.text = document['weight'];
          _priceText.text = document['price'].toString();
          _comapredPriceText.text = document['comparedPrice'].toString();
          var different = int.parse(_comapredPriceText.text) -
              double.parse(_priceText.text);
          discount = (different / int.parse(_comapredPriceText.text) * 100);
          image = document['productImage'];
          _descriptionText.text = document['description'];
          _categoryTextController.text = document['category']['mainCategory'];
          _subCategoryTextController.text = document['category']['subCategory'];
          dropdownValue = document['collection'];
          _stockTextController.text = document['stockQty'].toString();
          _lowStockTextController.text = document['lowStockQty'].toString();
          categoryImage = document['categoryImage'];
        });
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          FlatButton(
              onPressed: () {
                if (mounted) {
                  setState(() {
                    _editing = false;
                  });
                }
              },
              child: Text(
                'Edit',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      bottomSheet: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
                child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.black87,
                child: Center(
                    child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                )),
              ),
            )),
            Expanded(
                child: InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  EasyLoading.show(status: 'Saving...');
                }
                if (_image != null) {
                  //first upload new image and save data
                  _provider
                      .uploadProductImage(_image!.path, _productNameText.text)
                      .then((url) {
                    if (url != null) {
                      _provider.updateProduct(
                          context: context,
                          productName: _productNameText.text,
                          weight: _weightText.text,
                          stockQty: int.parse(_stockTextController.text),
                          sku: _skuText.text,
                          price: double.parse(_priceText.text),
                          lowStockQty: int.parse(_lowStockTextController.text),
                          description: _descriptionText.text,
                          collection: dropdownValue,
                          comparedPrice: int.parse(_comapredPriceText.text),
                          productId: widget.productId,
                          image: image,
                          category: _categoryTextController.text,
                          subCategory: _subCategoryTextController.text,
                          categoryImage: categoryImage);
                      EasyLoading.dismiss();
                    }
                  });
                } else {
                  //no need to change image, so just save new data. no need to upload image
                  _provider.updateProduct(
                      context: context,
                      productName: _productNameText.text,
                      weight: _weightText.text,
                      stockQty: int.parse(_stockTextController.text),
                      sku: _skuText.text,
                      price: double.parse(_priceText.text),
                      lowStockQty: int.parse(_lowStockTextController.text),
                      description: _descriptionText.text,
                      collection: dropdownValue,
                      comparedPrice: int.parse(_comapredPriceText.text),
                      productId: widget.productId,
                      image: image,
                      category: _categoryTextController.text,
                      subCategory: _subCategoryTextController.text,
                      categoryImage: categoryImage);
                  EasyLoading.dismiss();
                }
              },
              child: Container(
                color: Colors.deepOrangeAccent,
                child: Center(
                    child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                )),
              ),
            )),
          ],
        ),
      ),
      body: doc == null
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: [
                    AbsorbPointer(
                      absorbing: _editing,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('SKU:  '),
                                  Container(
                                    width: 50,
                                    child: TextFormField(
                                      controller: _skuText,
                                      style: TextStyle(fontSize: 12),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              controller: _productNameText,
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              controller: _weightText,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 80,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    prefixText: '\$',
                                  ),
                                  controller: _priceText,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Container(
                                width: 80,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    prefixText: '\$',
                                  ),
                                  controller: _comapredPriceText,
                                  style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.deepOrangeAccent),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    '${discount!.toStringAsFixed(0)}%OFF',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Inclusive of all Taxes',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          InkWell(
                            onTap: () {
                              _provider.getProductImage().then((image) {
                                setState(() {
                                  _image = image;
                                });
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 80, top: 40),
                              child: _image != null
                                  ? Image.file(_image!, height: 300)
                                  : Image.network(image!, height: 300),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'About this product',
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: TextFormField(
                              maxLines: null,
                              controller: _descriptionText,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(color: Colors.grey),
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Category',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: AbsorbPointer(
                                    absorbing:
                                        true, //this will block user entering category name manually
                                    child: TextFormField(
                                      controller: _categoryTextController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Select Category name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          hintText: 'not selected',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey))),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _editing ? false : true,
                                  child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CategoryList();
                                            }).whenComplete(() {
                                          setState(() {
                                            _categoryTextController.text =
                                                _provider.selectedCategory!;
                                            _visible = true;
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.edit_outlined)),
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _visible,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              child: Row(
                                children: [
                                  Text('Sub Category',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: TextFormField(
                                        controller: _subCategoryTextController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Select Subcategory name';
                                          }

                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'not selected',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey))),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SubCategoryList();
                                            }).whenComplete(() {
                                          setState(() {
                                            _subCategoryTextController.text =
                                                _provider.selectedSubCategory!;
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.edit_outlined)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  'Collection',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                DropdownButton<String>(
                                  hint: Text('Select Collection'),
                                  value: dropdownValue,
                                  icon: Icon(Icons.arrow_drop_down),
                                  onChanged: (value) {
                                    setState(() {
                                      dropdownValue = value;
                                    });
                                  },
                                  items: _collections
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text('Stock :'),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                  controller: _stockTextController,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Low Stock :'),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                  controller: _lowStockTextController,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
