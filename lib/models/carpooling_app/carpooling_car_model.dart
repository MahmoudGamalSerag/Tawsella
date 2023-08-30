class CarpoolingCarModel {
  late String uId;
  late String image;
  late String model;
  late String brand;
  late String license;
  late String userlicense;

  CarpoolingCarModel({
    required this.uId,
    required this.image,
    required this.model,
    required this.brand,
    required this.license,
    required this.userlicense,

  });

  CarpoolingCarModel.fromJson(Map<String, dynamic> json)
  {

    uId = json['uId'];
    image = json['image'];
    model = json['model'];
    brand = json['brand'];
    license = json['license'];
    userlicense = json['userlicense'];

  }

  Map<String, dynamic> toMap()
  {
    return {

      'uId':uId,
      'model':model,
      'image':image,
      'brand':brand,
      'license':license,
      'userlicense':userlicense,
    };
  }
}