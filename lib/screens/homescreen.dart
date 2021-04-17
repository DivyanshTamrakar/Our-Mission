import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:namma_badavane/config.dart';
import 'package:namma_badavane/models/complaint_model.dart';
import 'package:namma_badavane/models/department_model.dart';
import 'package:namma_badavane/screens/category_list_screen.dart';
import 'package:namma_badavane/screens/notification.dart';
import 'package:namma_badavane/services/complaint_service.dart';
import 'package:namma_badavane/services/department_service.dart';
import 'package:namma_badavane/utils/HttpResponse.dart';
import 'package:namma_badavane/utils/bottom_navigation.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:namma_badavane/widgets/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;

import 'language_screen.dart';

class HomeScreen extends StatefulWidget {
  static Color color = Color.fromRGBO(38, 40, 52, 1.0);
  static Color button_back = Color.fromRGBO(125, 140, 223, 1.0);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String language;
  List<Complaint> complaints = [];
  var complaintLength;
  var solutionlength;
  var solvedLength;
  var pendingLength;
  var arr = new List(9);
  List<Department> departments = [];
  List<String> kann = [
    "ರಸ್ತೆನಿರ್ವಹಣೆ",
    "ತ್ಯಾಜ್ಯ ಸಂಬಂಧಿತ",
    "ವಿದ್ಯುತ್",
    "ಆರೋಗ್ಯ ಇಲಾಖೆ",
    "ಉದ್ಯಾನವನ ಹಾಗೂ ಆಟದ ಮೈದಾನ",
    "ವಿದ್ಯಾಅಭ್ಯಾಸ ಮತ್ತು ಕಲ್ಯಾಣ ಯೋಜನೆಗಳು(ಸಹಾಯ)",
    "ಒಳಚರಂಡಿ",
    "ನೀರು",
    "ಇತರೆ"
  ];

  PreferenceData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      if(pref.getString("language") != null){
        language = pref.getString("language");
      }else{
        language = "English";
        pref.setString("language", "English");
      }

    });
    print(pref.getString("language"));
    print("language ========$language");
    print("token ========${pref.getString("token")}");
  }




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
    fetchData();
    fetchDataforStatCard();
    getSolutionDataForStatCard();

    StatusColor();
    PreferenceData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print(width);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color.fromRGBO(246, 244, 246, 1.0),
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          language == "English" ? "Departments" : "ಇಲಾಖೆಗಳು",
          style: TextStyle(color: Color.fromRGBO(173, 171, 184, 1.0)),
        ),
        backgroundColor: Color.fromRGBO(22, 14, 27, 1.0),
        actions: [
          GestureDetector(
            onTap: () {
              print("clicked");
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) => Language_selection(),
              ).then((value) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => BottomBarExample()));
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 30.0),
              child: Center(
                  child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.language_rounded, color: Colors.white),
                    color: button_icon_color,
                    onPressed: () {},
                  ),
                  Text(
                    language == "English" ?"Language":"ಭಾಷೆ",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
            ),
          ),
          IconButton(
            icon: Icon(Icons.notifications_active_outlined,
                color: Color.fromRGBO(67, 88, 185, 1.0)),
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
          ? SingleChildScrollView(
        scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.all(3.0), //divyansh editing
                // padding: EdgeInsets.all(12.0),
                child: GridView.builder(

                  shrinkWrap: true,
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
                                language == "English"
                                    ? departments[index].title
                                    : kann[index],
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
                )),
                // Line with Text
                Row(children: <Widget>[
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                        )),
                  ),
                  Text(language == "English"?'Complaint Status':'ದೂರು ಸ್ಥಿತಿ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                        )),
                  ),
                ]),
                // Status Card
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    padding: EdgeInsets.all(3.0),
                    children: <Widget>[
                      makeDashboardItem(
                          language == "English" ? "Registered" : "ನೋಂದಾಯಿಸಲಾಗಿದೆ",
                          Icons.insert_comment,
                          Colors.yellow,
                          Colors.black,
                          complaintLength.toString()),
                      makeDashboardItem(
                          language == "English" ? "Solved" : "ಪರಿಹರಿಸಲಾಗಿದೆ",
                          Icons.assignment_turned_in_rounded,
                          Colors.green,
                          Colors.white,
                          solutionlength.toString()),

                      makeDashboardItem(
                          language == "English" ? "Pending" : "ಬಾಕಿ ಉಳಿದಿದೆ",
                          Icons.pending_actions,
                          Colors.orangeAccent[400],
                          Colors.white,
                          pendingLength != null ? pendingLength.toString() : "0" ),
                    ],
                  ),
                ),
              ],
            ),
          )
          : Center(
        child: CircularProgressIndicator(),
      )
    ));
  }

  // stat card numbering

  fetchDataforStatCard() async {
    var resp = await HttpResponse.getResponse(service: '/complain');
    print("\n\n$resp\n\n");

    var response = jsonDecode(resp);
    print("\n\n${response.toString()}\n\n");

    setState(() {
      complaintLength = response['data'].length;
    });
  }

  getSolutionDataForStatCard() async {
    var resp = await HttpResponse.getResponse(service: '/solution');
    print("\n\n$resp\n\n");

    var response = jsonDecode(resp);
    print("\n\n${response.toString()}\n\n");

    setState(() {
      solutionlength = response['data'].length;
      if (solutionlength == null) {
        solutionlength = 0;
      }
      print(solutionlength);
      pendingLength = complaintLength - solutionlength;
      if (pendingLength == null) {
        pendingLength = 0;
      }
      print(pendingLength);

    });
  }


}


Card makeDashboardItem(String title, IconData icon, Color cardcolor,
    Color textcolor, String complaint) {
  return Card(
      elevation: 2.0,
      child: Container(
        decoration: BoxDecoration(color: cardcolor,borderRadius: BorderRadius.circular(4),),
        child: new InkWell(
          onTap: () {},
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 5.0),
                Center(
                    child: Icon(
                      icon,
                      size: 25.0,
                      color: Colors.white,
                    )),
                SizedBox(height: 5.0),
                new Center(
                  child: Container(
                    width: 110.0,
                    alignment: Alignment.center,
                    child: new Text(title,
                        textAlign: TextAlign.justify,
                        // overflow: TextOverflow.ellipsis,

                        style: new TextStyle(
                            fontSize: 18.0,
                            color: textcolor,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 2.0),
                new Center(
                  child: new Text(complaint,
                      style: new TextStyle(
                          fontSize: 25.0,
                          color: textcolor,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ),
      ));
}



