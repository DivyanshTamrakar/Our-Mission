import 'package:aws_translate/aws_translate.dart';
import 'package:flutter/material.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:namma_badavane/utils/HttpResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../config.dart';
import 'homescreen.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notification = [];
  String language = "";
  List<dynamic> title_kann=[];
  List<dynamic> description_kann=[];


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
    getaws();
  }

  getaws() async {
    AwsTranslate awsTranslate = AwsTranslate(
      poolId: poolId, // your pool id here
      region: region,
    ); // your region here

    print("outside loop");
    for (var i = 0; i < notification.length; i++) {
      print("inside loop");

      String translated1 = await awsTranslate
          .translateText(notification[i]['title'].toString(), to: 'kn');
      String translated2 = await awsTranslate
          .translateText(notification[i]['description'].toString(), to: 'kn');
      if (!mounted) return CircularProgressIndicator();
      setState(() {
        title_kann.add(translated1.toString());
        description_kann.add(translated2.toString());

        print("title kanana list ");
        print(title_kann);
        print("description kannada  list ");
        print(description_kann);
      });
    }

    print("title kanana list ");
    print(title_kann);
    print("descreption kanana list ");
    print(description_kann);
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
                                language == "English" ? notification[i]['title']:(title_kann.length > i      ? title_kann[i]  : 'Please wait...'),
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
                                language == "English" ? notification[i]['description']:(description_kann.length > i      ? description_kann[i]  : 'Please wait...'),
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
