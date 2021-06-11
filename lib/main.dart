import 'package:flutter/material.dart';
import './screens/LoginScreen.dart';
import './utils/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Our Mission',
      theme: ThemeData(
        primarySwatch: primary_color,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Screen(),

    );
  }
}
