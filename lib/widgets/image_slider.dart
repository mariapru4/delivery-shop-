import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/image_model.dart';

class ImageSlider extends StatelessWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Future getSilderImageFromDb() async {
    //   var _firestore = FirebaseFirestore.instance;
    //   QuerySnapshot snapshot = await _firestore.collection('slider').get();
    //   return snapshot.docs;
    // }
    Future<List<ImageModel>> getBanners() async {
      List<ImageModel> result = new List<ImageModel>.empty(growable: true);
      CollectionReference bannerRef =
          FirebaseFirestore.instance.collection('slider');
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
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3)),
                  items: banners
                      .map((e) => Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(e.img),
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
