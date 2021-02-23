import 'package:flutter/material.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:namma_badavane/utils/HttpResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'homescreen.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notification = [];
  String language = "";

  GetPreferData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      language = pref.getString("language");
    });
    print(pref.getString("language"));
    print("language ========$language");
  }


  getNotificationData() async {
    var resp = await HttpResponse.getResponse(service: '/notification');
    print("\n\n$resp\n\n");

    var response = jsonDecode(resp);
    print("\n\n${response.toString()}\n\n");

    setState(() {
      notification = response['data'];

      print("solutions list");
      print(notification);
      print(notification.length);
    });
  }

  @override
  void initState() {
    super.initState();
    getNotificationData();
    GetPreferData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HomeScreen.color,
        title: Text(
          language == "English"?'Notifications':'ಅಧಿಸೂಚನೆಗಳು',
          style: TextStyle(color: primary_text_color),
        ),
      ),
      body: (notification != null)
          ? (notification.length > 0)
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      itemCount: notification.length,
                      itemBuilder: (context, i) {
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: Colors.grey[300], width: 0.0),
                              borderRadius: BorderRadius.circular(4.0)),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(8.0),
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.message,
                                color: primary_color,
                                size: 30,
                              ),
                            ),
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                notification[i]['title'],
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: Text(
                                notification[i]['description'],
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              ),
                            ),
                          ),
                        );
                      }),
                )
              : Center(child: CircularProgressIndicator())
          : Center(
              child: Text("No complaint History Found",
                  textAlign: TextAlign.center)),
    );
  }
}
