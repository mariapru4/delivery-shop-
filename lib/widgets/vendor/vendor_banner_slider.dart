import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/services/store_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/image_model.dart';

class VendorBannerSlider extends StatefulWidget {
  const VendorBannerSlider({Key? key}) : super(key: key);

  @override
  _VendorBannerSliderState createState() => _VendorBannerSliderState();
}

class _VendorBannerSliderState extends State<VendorBannerSlider> {
  @override
  Widget build(BuildContext context) {
    Future<List<ImageModel>> getBanners() async {
      List<ImageModel> result = new List<ImageModel>.empty(growable: true);
      CollectionReference bannerRef =
          FirebaseFirestore.instance.collection('vendorbanner');
      QuerySnapshot snapshot = await bannerRef.get();
      snapshot.docs.forEach((element) {
        result.add(ImageModel.fromJson(element.data() as Map<String, dynamic>));
      });
      return result;
    }

    return Column(
      children: [
        FutureBuilder(
            future: getBanners(),
            builder: (_, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var banners = snapShot.data as List<ImageModel>;
                return CarouselSlider(
                  options: CarouselOptions(
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3)),
                  items: banners
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  e.img,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                );
              }
            })
      ],
    );
  }
}
