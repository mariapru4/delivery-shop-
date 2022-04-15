import 'dart:io';

import 'package:delivery_app/widgets/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class AddNewProduct extends StatefulWidget {
  static const String id = 'add-new-product';

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();
  List<String> _collections = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];
  String? dropdownValue;
  File? _image;
  bool _visible = false;
  bool _track = false;

  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _comparedPriceTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  var _stockTextController = TextEditingController();
  String? productName;
  String? productDescription;
  double? productPrice;
  double? productComparedPrice;
  String? productCollection;
  String? productSku;
  String? productCategory;
  String? productSubCategory;
  String? productWight;

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 2,
      initialIndex:
          1, // will keep initial index 1 to avoid text field clearing automatically
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          child: Text('Products / Add'),
                        ),
                      ),
                      FlatButton.icon(
                        icon: Icon(Icons.save_alt_outlined),
                        label: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            //only if filled necessary field
                            if (_categoryTextController.text.isNotEmpty) {
                              if (_subCategoryTextController.text.isNotEmpty) {
                                if (_image != null) {
                                  //image should ne selected
                                  //upload image to storage
                                  EasyLoading.show(status: 'Saving...');
                                  _provider
                                      .uploadProductImage(
                                          _image!.path, productName)
                                      .then((url) {
                                    if (url != null) {
                                      //upload product data to firestore
                                      EasyLoading.dismiss();
                                      _provider.saveProductDataToDb(
                                          context: context,
                                          comparedPrice: int.parse(
                                              _comparedPriceTextController
                                                  .text),
                                          collection: dropdownValue,
                                          description: productDescription,
                                          lowStockQty: int.parse(
                                              _lowStockTextController.text),
                                          price: productPrice,
                                          sku: productSku,
                                          stockQty: int.parse(
                                              _stockTextController.text),
                                          weight: productWight,
                                          productName: productName);
                                      setState(() {
                                        //clear all the existing value after saved product
                                        _formKey.currentState!.reset();
                                        _comparedPriceTextController.clear();
                                        dropdownValue = null;
                                        _subCategoryTextController.clear();
                                        _categoryTextController.clear();
                                        _track = false;
                                        _image = null;
                                        _visible = false;
                                      });
                                    } else {
                                      _provider.alertDialog(
                                          context: context,
                                          title: 'PRODUCT UPLOAD',
                                          content:
                                              'Failed to upload product image');
                                    }
                                  });
                                } else {
                                  _provider.alertDialog(
                                      context: context,
                                      title: 'PRODUCT IMAGE',
                                      content: 'Product Image not selected');
                                }
                              } else {
                                _provider.alertDialog(
                                    context: context,
                                    title: 'Sub Category',
                                    content: 'Sub Category no selected');
                              }
                            } else {
                              _provider.alertDialog(
                                  context: context,
                                  title: 'Main Category',
                                  content: 'Main Category no selected');
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              TabBar(
                  indicatorColor: Theme.of(context).primaryColor,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.black54,
                  tabs: [
                    Tab(
                      text: 'GENERAL',
                    ),
                    Tab(
                      text: 'INVENTORY',
                    ),
                  ]),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: TabBarView(children: [
                    ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter product name';
                                  }
                                  setState(() {
                                    productName = value;
                                  });
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Product Name',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey))),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                maxLength: 500,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter  description';
                                  }
                                  setState(() {
                                    productDescription = value;
                                  });
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Product Description',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey))),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    _provider.getProductImage().then((image) {
                                      setState(() {
                                        _image = image;
                                      });
                                    });
                                  },
                                  child: SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Card(
                                      child: Center(
                                        child: _image == null
                                            ? Text('Selected Image')
                                            : Image.file(_image!),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter selling price';
                                  }
                                  setState(() {
                                    productPrice = double.parse(value);
                                  });
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: 'Price ',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey))),
                              ),
                              TextFormField(
                                controller: _comparedPriceTextController,
                                validator: (value) {
                                  if (productPrice! > double.parse(value!)) {
                                    //always compared price should be higher
                                    return 'Compared price should be higher than selling price';
                                  }
                                  setState(() {
                                    productComparedPrice = double.parse(value);
                                  });
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: 'Compared Price ',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey))),
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
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter SKU';
                                  }
                                  setState(() {
                                    productSku = value;
                                  });
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'SKU',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey))),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 10),
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
                                              enabledBorder:
                                                  UnderlineInputBorder(
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
                                                return CategoryList();
                                              }).whenComplete(() {
                                            setState(() {
                                              _categoryTextController.text =
                                                  _provider.selectedCategory;
                                              _visible = true;
                                            });
                                          });
                                        },
                                        icon: Icon(Icons.edit_outlined))
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: _visible,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 20),
                                  child: Row(
                                    children: [
                                      Text('Sub Category',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: AbsorbPointer(
                                          absorbing: true,
                                          child: TextFormField(
                                            controller:
                                                _subCategoryTextController,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Select Subcategory name';
                                              }

                                              return null;
                                            },
                                            decoration: InputDecoration(
                                                hintText: 'not selected',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey))),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SubCategoryList();
                                                }).whenComplete(() {
                                              setState(() {
                                                _subCategoryTextController
                                                        .text =
                                                    _provider
                                                        .selectedSubCategory;
                                              });
                                            });
                                          },
                                          icon: Icon(Icons.edit_outlined)),
                                    ],
                                  ),
                                ),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter product wight';
                                  }
                                  setState(() {
                                    productWight = value;
                                  });
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Wight',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey))),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: Text('Track Inventory'),
                            activeColor: Theme.of(context).primaryColor,
                            subtitle: Text(
                              'Switch ON to track Inventory',
                              style: TextStyle(color: Colors.grey),
                            ),
                            value: _track,
                            onChanged: (selected) {
                              setState(() {
                                _track = !_track;
                              });
                            },
                          ),
                          Visibility(
                            visible: _track,
                            child: SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: Card(
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _stockTextController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: 'Inventory Quantity',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey))),
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: _lowStockTextController,
                                        decoration: InputDecoration(
                                            labelText:
                                                'Inventory low stock quantity',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey))),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
