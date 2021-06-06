import 'package:flutter/services.dart';
import './screens/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
const String BASE_URL = "https://namma-badavane.herokuapp.com";// heroku live


Future<void> statusColor() async {
   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: HomeScreen.color, // navigation bar color
    statusBarColor:  HomeScreen.color, // status bar color
  ));
}



Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String accessToken = prefs.getString("token");
  return accessToken;
}


  void userToken(){
  getToken().then((value) =>  {
     value
  });

}





