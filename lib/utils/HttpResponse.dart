
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:namma_badavane/config.dart';
import 'package:shared_preferences/shared_preferences.dart';




class HttpResponse{
  static Future<String> postResponse({String service,Map data}){
    String url=BASE_URL+service;
    String body = json.encode(data);
    print('Url==$url');
    return http.post(url,body: body,headers: {"Content-Type": "application/json"}).then((http.Response response){
      if(response.statusCode<200 || response.statusCode>400 || json==null){
        print('HttpResponse=='+response.body.toString());
        throw new Exception("Error while fetching============================");
      }
      return response.body.toString();
    });
  }


  static Future<String> getResponse({String service}) async{

    String url=BASE_URL+service;
    print('Url==$url');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("token");
    print("DIvyansh");
    print(accessToken);
    // http.Response response= await http.get(url,headers: {"Authorization": token});
    http.Response response= await http.get(url,headers: {"Authorization": accessToken});
    if (response.statusCode < 200 || response.statusCode > 400 || json == null) {
      print("Error occur===============================");
      print('HttpResponse=='+response.body.toString());

      return throw new Exception("Error while fetching============================");
    }
    else
      return response.body.toString();
  }

}
