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

    print("user token ========  ${prefs.getString("token")}");
    print("user default language in shared preference  ========  ${prefs.getString("language")}");


    var usertoken = prefs.getString("token");
    if (usertoken == null) {
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Screen()));
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: splash_background,
        body: InkWell(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset('assets/bidar.jpg',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center),
              ClipRRect(
                // Clip it cleanly.
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.grey.withOpacity(0.1),
                    alignment: Alignment.center,
                  ),
                ),
              ),

              // Container(
              //   child: Image.asset('assets/bidar.jpg',
              //       fit: BoxFit.cover,
              //       height: double.infinity,
              //       width: double.infinity,
              //       alignment: Alignment.center),
              // ),
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
                              vertical: 5, horizontal: 60),
                          child: Container(
                            height: 5,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Namma",
                                  style: TextStyle(
                                      fontSize: 40, color: button_text_color)),
                              Text("Badavane",
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: button_text_color,
                                      fontWeight: FontWeight.bold))
                            ])
                      ],
                    )),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: <Widget>[
                          // CircularProgressIndicator(),
                          Container(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Spacer(),
                                Text(
                                    "Don't worry we're here to solve your Issues",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: button_text_color)),
                                Spacer(),
                              ]),
                          // CircularProgressIndicator(),

                          SizedBox(
                            width: 140,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Powered by",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: button_text_color)),
                                  Image.asset(
                                    "assets/footer.png",
                                    height: 65,
                                    width: 65,
                                    color: Colors.white,
                                  ),
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
