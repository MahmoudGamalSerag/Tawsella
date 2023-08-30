import 'dart:convert';

import 'package:http/http.dart'as http;
class RequestAssistants{
  static Future<dynamic> getRequest(String url)async
  {
    http.Response response=await http.get(Uri.parse(url));
    try{
      if(response.statusCode==200)
      {
        String jsonDate=response.body;
        var decodeData=jsonDecode(jsonDate);
        return decodeData;
      }
      else
      {
        return "failed";
      }
    }catch(exp){
      return "failed";
    }
  }
}