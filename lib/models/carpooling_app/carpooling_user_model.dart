class CarpoolingUserModel {
  late String name;
  late String email;
  late String phone;
  late String uId;
  late String image;
  late  String cover;
  late  String address;
  late  int drivertrips;
  late  int ridertrips;
  late  int rate;
  late  int rateNumbers;
  late bool isEmailVerified;

  CarpoolingUserModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.uId,
    required this.image,
    required this.cover,
    required this.address,
    required this.drivertrips,
    required this.ridertrips,
    required this.rate,
    required this.rateNumbers,
    required this.isEmailVerified,
  });

  CarpoolingUserModel.fromJson(Map<String, dynamic> json)
  {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    address = json['address'];
    ridertrips = json['ridertrips'];
    drivertrips = json['drivertrips'];
    rate = json['rate'];
    rateNumbers = json['rateNumbers'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'name':name,
      'email':email,
      'phone':phone,
      'uId':uId,
      'image':image,
      'cover':cover,
      'address':address,
      'rate':rate,
      'rateNumbers':rateNumbers,
      'ridertrips':ridertrips,
      'drivertrips':drivertrips,
      'isEmailVerified':isEmailVerified,
    };
  }
}