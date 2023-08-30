class CarpoolingChatObjectModel {

  late String uId;
  late String dateTime;


  CarpoolingChatObjectModel({
    required this.uId,
    required this.dateTime,
  });

  CarpoolingChatObjectModel.fromJson(Map<String, dynamic> json)
  {
    uId = json['uId'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'uId':uId,
      'dateTime':dateTime,
    };
  }
}