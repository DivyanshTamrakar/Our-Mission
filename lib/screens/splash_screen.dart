import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namma_badavane/config.dart';
import 'package:namma_badavane/screens/sign_up_screen.dart';
import 'package:namma_badavane/utils/bottom_navigation.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'complaint_form_screen.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _versionName = 'V1.0';
  final splashDelay = 5;
  // File image;

  // _imgFromCamera() async {
  //   image = (await ImagePicker.pickImage(
  //       source: ImageSource.camera, imageQuality: 50)) as File;
  // }

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

    print(prefs.getString("token"));

    var usertoken = prefs.getString("token");
    if (usertoken == null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => BottomBarExample()));
    }

    // Iyyer bhai editing
    // var token = await getToken();
    //   if(token==null)
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()));
    //   else
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (BuildContext context) => BottomBarExample()));
    //
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: splash_background,
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: height * 0.28,
                        // color: Colors.amber,
                        child: Image.asset('assets/splash_icon.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 60),
                        child: Container(
                          height: 5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Namma", style: TextStyle(fontSize: 40)),
                            Text("Badavane",
                                style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold))
                          ])
                    ],
                  )),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Container(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Spacer(),
                            Text("Don't worry we're here to solve your Issues",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            Spacer(),
                          ])
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
