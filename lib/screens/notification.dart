import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/HttpResponse.dart';
import 'dart:convert';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notification = [];

  getNotificationData() async {
    var resp = await HttpResponse.getResponse(service: '/notification');
    print("\n\n$resp\n\n");
    var response = jsonDecode(resp);
    print("\n\n${response.toString()}\n\n");

    setState(() {
      notification = response['data'];
    });
  }

  @override
  void initState() {
    super.initState();
    getNotificationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(67, 88, 185, 1.0),
        title: Text(
          'Notifications',
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
              : Center(
                  child: Text("No Notification Found",
                      textAlign: TextAlign.center))
          : Center(
              child: Text("No complaint History Found",
                  textAlign: TextAlign.center)),
    );
  }
}
