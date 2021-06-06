import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/screen.dart';
import '../utils/HttpResponse.dart';
import '../utils/colors.dart';
import '../screens/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "", contact = "", profile = "";
  String dropdownValue = 'Select Ward';

  getUserData() async {
    var resp = await HttpResponse.getResponse(
      service: '/users/profile',
    );
    print("\n\n$resp\n\n");

    var response = jsonDecode(resp);
    print("\n\n${response.toString()}\n\n");

    setState(() {
      name = response['data']['name'].toString();
      contact = response['data']['contact'].toString();
      profile = response['data']['profile'].toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            height: 0.5 * height,
            width: width,
            color: HomeScreen.color,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: profile == "null"
                        ? Image.asset(
                            "assets/profile_placeholder.png",
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            profile,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  name == "" ? "Your Name" : name.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: button_text_color,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  contact == "" ? "Mobile No" : contact.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: button_text_color,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
                elevation: 5,
                child: Center(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    iconSize: 30,
                    elevation: 16,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    underline: Container(
                      height: 2,
                      color: Colors.transparent,
                    ),
                    onChanged: (String newValue) async {
                      setState(() {
                        dropdownValue = newValue;
                      });
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString("dropvalue", dropdownValue);
                    },
                    items: <String>['Select Ward', 'Ward no 13']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      );
                    }).toList(),
                  ),
                )),
          ),
          Card(
            elevation: 5,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            EditProfileScreen(newUser: false)));
                getUserData();
              },
              child: ListTile(
                leading: Icon(Icons.edit, color: button_color),
                title: Text(
                  "Edit Profile",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.arrow_forward, color: Colors.blueAccent),
              ),
            ),
          ),
          Card(
            elevation: 5,
            child: InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                print("token cleared");
                print(prefs.getString("token"));
                print("language cleared");
                print(prefs.getString("language"));
                Navigator.pop(context);
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Screen()));
              },
              child: ListTile(
                leading: Icon(Icons.logout, color: button_color),
                title: Text(
                  "Log out",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.arrow_forward, color: Colors.blueAccent),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
