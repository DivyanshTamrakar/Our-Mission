import 'package:flutter/material.dart';

Widget getProgressDialog(BuildContext context, String message) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    content: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text(
            message,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
  );
}

Widget oneButtonDialog(
    {BuildContext context,
    String title,
    String content,
    String actionTitle,
    Function function}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    title: Text(title),
    content: Text(content),
    actions: <Widget>[
// usually buttons at the bottom of the dialog
      new TextButton(
        child: Text(actionTitle),
        onPressed: () {
          if (function != null) {
            function();
          }
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}

Widget twoButtonDialog(
    {BuildContext context,
    String title,
    String content,
    String actionOneTitle,
    Function functionOne,
    String actionTwoTitle,
    Function functionTwo}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    title: Text(title),
    content: Text(content),
    actions: <Widget>[
   // usually buttons at the bottom of the dialog
      TextButton(
        child: new Text(actionOneTitle),
        onPressed: () {
          functionOne();
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: new Text(actionTwoTitle),
        onPressed: () {
          functionTwo();
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
