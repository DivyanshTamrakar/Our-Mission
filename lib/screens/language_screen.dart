import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:namma_badavane/screens/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class Language_selection extends StatefulWidget {
  @override
  _Language_selectionState createState() => new _Language_selectionState();
}

class _Language_selectionState extends State<Language_selection> {
  String _group_value = "English";

  @override
  void initState() {
    super.initState();
    // prefShared();
  }

  prefShared() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("language") == null) {
      if (_group_value == "English") {
        if (pref.getString("language") == null) {
          pref.setString("language", "English");
        } else {
          pref.setString("language", "English");
        }
      } else {
        if (pref.getString("language") == null) {
          pref.setString("language", "Kannada");
        } else {
          pref.setString("language", "Kannada");
        }
      }
    } else {
      if (_group_value == "English") {
        if (pref.getString("language") == null) {
          pref.setString("language", "English");
        } else {
          pref.setString("language", "English");
        }
      } else {
        if (pref.getString("language") == null) {
          pref.setString("language", "Kannada");
        } else {
          pref.setString("language", "Kannada");
        }
      }
    }

    print(pref.getString("language"));
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 100.0,
      color: Colors.blue,
      child: new Container(
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0))),
          child: Column(
            children: [
              SizedBox(
                height: 15.0,
              ),
              Text(
                "Choose Your Language",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                          value: "English",
                          groupValue: _group_value,
                          onChanged: (value) {
                            setState(() {
                              _group_value = value;
                              prefShared();
                            });
                          }),
                      Text("Engish"),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: "Kannada",
                          groupValue: _group_value,
                          onChanged: (value) {
                            setState(() {
                              _group_value = value;
                              prefShared();
                            });
                          }),
                      Text("Kannada"),
                    ],
                  )
                ],
              ),
              // Text(
              //   _group_value
              //
              // ),
            ],
          )),
    );
  }
}
