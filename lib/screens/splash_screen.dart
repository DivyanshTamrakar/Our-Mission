import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namma_badavane/config.dart';
import 'package:namma_badavane/screens/screen.dart';
import 'package:namma_badavane/screens/sign_up_screen.dart';
import 'package:namma_badavane/utils/bottom_navigation.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'complaint_form_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _versionName = 'V1.0';
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
    print("user default language in shared preference  ========  ${prefs.getString("language")}");


    var usertoken = prefs.getString("token");

    if (usertoken == null) {

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
