class ImageModel {
  late String img;
  ImageModel({required this.img});

  ImageModel.fromJson(Map<String, dynamic> json) {
    img = json['image'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    return data;
  }
}
