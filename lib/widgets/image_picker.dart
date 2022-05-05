import 'dart:io';

import 'package:delivery_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPicCard extends StatefulWidget {
  static const id = 'image-screen';
  @override
  State<ShopPicCard> createState() => _ShopPicCardState();
}

class _ShopPicCardState extends State<ShopPicCard> {
  File? _image;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          _authData.getImage().then((image) {
            setState(() {
              _image = image as File;
            });
            if (image != null) {
              _authData.isPicAvail = true;
            }
          });
        },
        child: SizedBox(
          height: 200,
          width: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Card(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: _image == null
                      ? Center(
                          child: Text(
                          'Add Shop Image',
                          style: TextStyle(color: Colors.grey),
                        ))
                      : Image.file(
                          _image!,
                          fit: BoxFit.fill,
                        )),
            ),
          ),
        ),
      ),
    );
  }
}
