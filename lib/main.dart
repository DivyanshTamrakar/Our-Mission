import 'package:flutter/material.dart';
import 'package:namma_badavane/screens/screen.dart';
import 'package:namma_badavane/utils/colors.dart';

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
      home: Screen(),

    );
  }
}
