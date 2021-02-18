import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namma_badavane/config.dart';
import 'package:namma_badavane/models/department_model.dart';
import 'package:namma_badavane/screens/category_list_screen.dart';
import 'package:namma_badavane/screens/notification.dart';
import 'package:namma_badavane/services/department_service.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:namma_badavane/widgets/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  static Color color = Color.fromRGBO(38, 40, 52, 1.0);
  static Color button_back = Color.fromRGBO(125,140,223,1.0);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();

      // For testing purposes print the Firebase Messaging token
      String fcm_token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $fcm_token");
      _initialized = true;
    }
  }
  GoogleTranslator translator = new GoogleTranslator();
  String out;
  var arr = new List(9);
  List<Department> departments = [];
  List<String> kann = ["ರಸ್ತೆನಿರ್ವಹಣೆ","ತ್ಯಾಜ್ಯ ಸಂಬಂಧಿತ","ವಿದ್ಯುತ್","ಆರೋಗ್ಯ ಇಲಾಖೆ","ಉದ್ಯಾನವನ ಹಾಗೂ ಆಟದ ಮೈದಾನ","ವಿದ್ಯಾಅಭ್ಯಾಸ ಮತ್ತು ಕಲ್ಯಾಣ ಯೋಜನೆಗಳು(ಸಹಾಯ)","ಒಳಚರಂಡಿ","ನೀರು","ಇತರೆ"];

  fetchData() async {
    var data = await DepartmentApi().getAllDepartments();
    setState(() {
      departments = data;
         });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    fetchData();
    StatusColor();
 }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print(width);
     return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Departments",
          style: TextStyle(color: primary_text_color),
        ),

        backgroundColor: HomeScreen.color,
        actions: [
          IconButton(
            icon:
                Icon(Icons.notifications_active_outlined, color: Colors.white),
            color: button_icon_color,
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => NotificationScreen()));
            },
          )
        ],
      ),
      body: (departments.length > 1)
          ? Container(
              margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.all(3.0), //divyansh editing
              // padding: EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: departments.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (width < 350) ? 2 : 3,
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 15.0),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => CategoryListScreen(
                                  departments: departments,
                                  departmentNumber: index)));
                    },
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                                height: (width < 350)
                                    ? height * 0.13
                                    : height * 0.07,
                                child: Image.network(departments[index].file)),
                            Divider(),
                            Text(
                              departments[index].title,
                              // out,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: departments[index].title.length < 20
                                      ? 12
                                      : 9,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ))
          : Center(
              child: CircularProgressIndicator(),
            ),
    ));
  }
}
