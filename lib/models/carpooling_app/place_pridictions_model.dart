class PlacePredictionsModel
{
  late String secondaryText;
  late String mainText;
  late String placeId;


  PlacePredictionsModel({
    required this.secondaryText,
    required this.mainText,
    required this.placeId,

  });

  PlacePredictionsModel.fromJson(Map<String, dynamic> json)
  {
    secondaryText = json["structured_formatting"]['secondary_text'];
    mainText = json['structured_formatting']['main_text'];
    placeId = json['place_id'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'secondary_text':secondaryText,
      'main_text':mainText,
      'place_id':placeId,
    };
  }
}