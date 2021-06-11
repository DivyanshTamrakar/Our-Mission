import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../screens/LoginScreen.dart';
import '../utils/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 3;

  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }



  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("user token ========  ${prefs.getString("token")}");
    var userToken = prefs.getString("token");
    if (userToken == null) {

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Screen()));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => BottomBarExample()));
    }


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: InkWell(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset('assets/poster.jpg',
                  fit: BoxFit.fill,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center),
                        ],
          ),
        ),
      ),
    );
  }
}
