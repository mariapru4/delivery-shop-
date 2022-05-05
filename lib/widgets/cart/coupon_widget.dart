import 'dart:ui';

import 'package:delivery_app/providers/coupon_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class CouponWidget extends StatefulWidget {
  final String couponVendor;
  CouponWidget(this.couponVendor);
  @override
  _CouponWidgetState createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  Color color = Colors.grey;
  bool _enable = false;
  bool _visible = false;

  var _couponText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var _coupon = Provider.of<CouponProvider>(context);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Row(children: [
              Expanded(
                child: SizedBox(
                    height: 38,
                    child: TextField(
                      controller: _couponText,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText: 'Enter Coupon',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      onChanged: (String value) {
                        if (value.length < 3) {
                          setState(() {
                            color = Colors.grey;
                            _enable = false;
                          });
                          if (value.isNotEmpty) {
                            setState(() {
                              color = Theme.of(context).primaryColor;
                              _enable = true;
                            });
                          }
                        }
                      },
                    )),
              ),
              AbsorbPointer(
                absorbing: _enable ? false : true,
                child: OutlineButton(
                  borderSide: BorderSide(color: color),
                  onPressed: () {
                    EasyLoading.show(status: 'Validating Coupon ...');
                    _coupon
                        .getCouponDetails(_couponText.text, widget.couponVendor)
                        .then((value) {
                      if (value.data() == null) {
                        setState(() {
                          _coupon.discountRate = 0;
                          _visible = false;
                        });
                        EasyLoading.dismiss();
                        showDialog(_couponText.text, 'Not valid');
                        return;
                      }
                      if (_coupon.expired == false) {
                        //not expired,coupon is valid
                        setState(() {
                          _visible = true;
                        });
                        EasyLoading.dismiss();
                        return;
                      }
                      if (_coupon.expired == true) {
                        //not expired,coupon is valid
                        setState(() {
                          _coupon.discountRate = 0;
                          _visible = false;
                        });
                        EasyLoading.dismiss();
                        showDialog(_couponText.text, 'Expired');
                      }
                    });
                  },
                  child: Text(
                    'Apply',
                    style: TextStyle(color: color),
                  ),
                ),
              ),
            ]),
          ),
          Visibility(
            visible: _visible,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DottedBorder(
                  child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.deepOrangeAccent.withOpacity(.4)),
                      width: MediaQuery.of(context).size.width - 80,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('Successfully Applied'),
                          ),
                          Divider(
                            color: Colors.grey[800],
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        right: -5,
                        top: -10,
                        child: IconButton(
                            onPressed: () {
                              _coupon.discountRate = 0;
                              _visible = false;
                              _couponText.clear();
                            },
                            icon: Icon(Icons.clear)))
                  ],
                ),
              )),
            ),
          )
        ],
      ),
    );
  }

  showDialog(code, validity) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('APPLT COUPON'),
            content: Text(
                'This discount coupon $code you have entered is $validity. Please try with another code'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }
}
