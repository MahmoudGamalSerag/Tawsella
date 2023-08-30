class AddressModel
{
  //late String PlaceFormattedAddress;
  late String PlaceName;
  late String PlaceId;
  late double latitude;
  late double longitude;


  AddressModel({
  //  required this.PlaceFormattedAddress,
    required this.PlaceName,
     required this.PlaceId,
    required this.latitude,
    required this.longitude,
  });

  AddressModel.fromJson(Map<String, dynamic> json)
  {
 //   PlaceFormattedAddress = json['PlaceFormattedAddress'];
    PlaceName = json['PlaceName'];
    PlaceId = json['PlaceId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toMap()
  {
    return {
    //  'PlaceFormattedAddress':PlaceFormattedAddress,
      'PlaceName':PlaceName,
      'PlaceId':PlaceId,
      'latitude':latitude,
      'longitude':longitude,
    };
  }
}