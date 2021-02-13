import 'package:flutter/services.dart';
import 'package:namma_badavane/screens/homescreen.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String BASE_URL = "http://nammabadavane-env.eba-zmg46rkq.ap-south-1.elasticbeanstalk.com";
const token='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJOYW1tYUJhZGF2YW5lIEN1c3RvbWVycyIsInN1YiI6IjYwMWQ2NjJmYTc2MDI5NWUyMWYyZmVjMCIsImlhdCI6MTYxMjYxNDg3NTYxNywiZXhwIjoxNjI4MTY2ODc1NjE3fQ.HNszNclBJXN6MLc73K-L4lRXyf-aTMetJjsrc-vt0P0';



Future<String> StatusColor() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: HomeScreen.color, // navigation bar color
    statusBarColor:  HomeScreen.color, // status bar color
  ));
}



Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String accessToken = await prefs.getString("token");
  return accessToken;
}


   String userToken(){
  String usertoken;
  getToken().then((value) =>  {
    print(value),
     usertoken = value
  });

}





