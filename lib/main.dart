import 'package:flutter/material.dart';
import 'package:namma_badavane/location_practise.dart';
import 'package:namma_badavane/screens/category_list_screen.dart';
import 'package:namma_badavane/screens/complaint_form_screen.dart';
import 'package:namma_badavane/screens/homescreen.dart';
import 'package:namma_badavane/utils/bottom_navigation.dart';
import 'package:namma_badavane/screens/history_screen.dart';
import 'package:namma_badavane/screens/notification.dart';
import 'package:namma_badavane/screens/otp_screen.dart';
import 'package:namma_badavane/screens/edit_profile_screen.dart';
import 'package:namma_badavane/screens/sign_up_screen.dart';
import 'package:namma_badavane/screens/submitted_screen.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'screens/complaint_detail_screen.dart';
import 'package:namma_badavane/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Namma Badavane',
      theme: ThemeData(
          primarySwatch: primary_color,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
      // home: BottomBarExample(),
      // home:SubmittedScreen(),
      // home : EditProfileScreen(newUser: true,)
      // home : EditProfileScreen(newUser: false,)
      // home: Location(),
      //  home: HomeScreen(),
      home: SplashScreen(),
      // home: ComplaintFormScreen(),
    );
  }
}
