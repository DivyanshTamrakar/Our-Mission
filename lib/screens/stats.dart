import 'dart:convert';

import 'package:aws_translate/aws_translate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namma_badavane/models/complaint_model.dart';
import 'package:namma_badavane/screens/complaint_detail_screen.dart';
import 'package:namma_badavane/screens/homescreen.dart';
import 'package:namma_badavane/services/complaint_service.dart';
import 'package:namma_badavane/utils/HttpResponse.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import '../config.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<Complaint> complaints = [];
  String language = "";
  var complaintLength;
  var solutionlength;
  var solvedLength;
  var pendingLength;

  fetchData() async {
    var data = await ComplaintApi().getAllComplaints();
    setState(() {
      complaintLength = data.length;
    });
  }

  getSolutionData() async {
    var resp = await HttpResponse.getResponse(service: '/users/solution/all');
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

  GetPreferData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      language = pref.getString("language");
    });
    print(pref.getString("language"));
    print("language ========$language");
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    getSolutionData();
    GetPreferData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
                language == "English" ? "Complaint Status" : "ದೂರು ಸ್ಥಿತಿ")),
        elevation: .1,
        backgroundColor: HomeScreen.color,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            makeDashboardItem(
                language == "English" ? "Raised Complaint" : "ದೂರು ಎತ್ತಿದೆ",
                Icons.insert_comment,
                Colors.yellow,
                Colors.black, complaintLength.toString()),
            makeDashboardItem(
                language == "English" ? "Solved Complaint" : "ಪರಿಹರಿಸಿದ ದೂರು",
                Icons.assignment_turned_in_rounded,
                Colors.green,
                Colors.white,
                solutionlength.toString()),
            makeDashboardItem(
                language == "English" ? "Pending Complaint" : "ದೂರು ಬಾಕಿ ಉಳಿದಿದೆ",
                Icons.pending_actions,
                Colors.orangeAccent[400],
                Colors.white,
                pendingLength.toString()),
          ],
        ),
      ),
    );
  }
}

// Card global design
Card makeDashboardItem(String title, IconData icon, Color cardcolor,
    Color textcolor, String complaint) {
  return Card(
      elevation: 5.0,
      margin: new EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(color: cardcolor),
        child: new InkWell(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              SizedBox(height: 10.0),
              Center(
                  child: Icon(
                icon,
                size: 40.0,
                color: Colors.white,
              )),
              SizedBox(height: 20.0),
              new Center(
                child: new Text(title,
                    style: new TextStyle(
                        fontSize: 18.0,
                        color: textcolor,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 0.0),
              new Center(
                child: new Text(complaint,
                    style: new TextStyle(
                        fontSize: 30.0,
                        color: textcolor,
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ));
}

