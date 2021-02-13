import 'package:flutter/material.dart';
import 'package:namma_badavane/utils/colors.dart';

import 'homescreen.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HomeScreen.color,
        title: Text('Notifications',
        style: TextStyle(
          color: primary_text_color
        ),),
      ),
      body: Container(
        height: height,
        width: width,
        child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, i) {
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    side: new BorderSide(color: Colors.grey[300], width: 1.0),
                    borderRadius: BorderRadius.circular(4.0)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.message, color: primary_color,size: 35,),
                  ),
                  title: Text(
                    "jschv sjh jh vfj vjkh fjkv fjk vj fjkv jf vj fdj vjhre fvhhr ikbgf is dslj hfj fkdg khg hjl dgh jhf gkb y ufghkhgfi kjckvhkfghcvkjbcjvhbfjhcbvlhfcbvvfhbhcjblvfb",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
