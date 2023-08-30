class DirectionModel
{
  late String distanceText;
  late String durationText;
  late String encodedPoints;
  late int distanceValue;
  late int durationValue;


  DirectionModel({
      required this.distanceText,
    required this.durationText,
    required this.encodedPoints,
    required this.distanceValue,
    required this.durationValue,
  });

  DirectionModel.fromJson(Map<String, dynamic> json)
  {
    distanceText = json['distanceText'];
    durationText = json['durationText'];
    encodedPoints = json['encodedPoints'];
    distanceValue = json['distanceValue'];
    durationValue = json['durationValue'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'distanceText':distanceText,
      'durationText':durationText,
      'encodedPoints':encodedPoints,
      'distanceValue':distanceValue,
      'durationValue':durationValue,
    };
  }
}