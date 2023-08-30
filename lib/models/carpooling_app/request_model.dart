class RequestModel {
  late String senderId;
  late String sendername;
  late String senderImage;
  late String senderStart;
  late String senderFinish;
  late String receiverId;
  late String dateTime;
  late String type;
  late bool read;

  RequestModel({
    required this.senderId,
    required this.sendername,
    required this.senderStart,
    required this.senderFinish,
    required this.senderImage,
    required this.receiverId,
    required this.dateTime,
    required this.type,
    required this.read,
  });

  RequestModel.fromJson(Map<String, dynamic> json)
  {
    senderId = json['senderId'];
    sendername = json['sendername'];
    senderStart = json['senderStart'];
    senderFinish = json['senderFinish'];
    senderImage = json['senderImage'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    type = json['type'];
    read = json['read'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'senderId':senderId,
      'sendername':sendername,
      'senderStart':senderStart,
      'senderFinish':senderFinish,
      'senderImage':senderImage,
      'receiverId':receiverId,
      'dateTime':dateTime,
      'type':type,
      'read':read,
    };
  }
}