class TripModel {
  late String uId;
  late String dateTime;
  late String startName;
  late double startLatitude;
  late double startLongitude;
  late String finishName;
  late double finishLatitude;
  late double finishLongitude;
  late int freeSeats;
  late bool isActive;

  TripModel({
    required this.uId,
    required this.dateTime,
    required this.startName,
    required this.startLatitude,
    required this.startLongitude,
    required this.finishName,
    required this.finishLatitude,
    required this.finishLongitude,
    required this.freeSeats,
    required this.isActive,
  });

  TripModel.fromJson(Map<String, dynamic> json)
  {
    uId = json['uId'];
    dateTime = json['dateTime'];
    startName = json['startName'];
    startLatitude = json['startLatitude'];
    startLongitude = json['startLongitude'];
    finishName = json['finishName'];
    finishLatitude = json['finishLatitude'];
    finishLongitude = json['finishLongitude'];
    freeSeats = json['freeSeats'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'uId':uId,
      'dateTime':dateTime,
      'startName':startName,
      'startLatitude':startLatitude,
      'startLongitude':startLongitude,
      'finishName':finishName,
      'finishLatitude':finishLatitude,
      'finishLongitude':finishLongitude,
      'freeSeats':freeSeats,
      'isActive':isActive,
    };
  }
}