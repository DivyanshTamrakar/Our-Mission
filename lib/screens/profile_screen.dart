
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namma_badavane/models/user_model.dart';
import 'package:namma_badavane/screens/complaint_form_screen.dart';
import 'package:namma_badavane/screens/edit_profile_screen.dart';
import 'package:namma_badavane/screens/sign_up_screen.dart';
import 'package:namma_badavane/services/auth_service.dart';
import 'package:namma_badavane/utils/HttpResponse.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name="",contact="";

  getUserData()async{

    var resp = await HttpResponse.getResponse(
        service: '/users/profile',);
    print("\n\n$resp\n\n");

    var response = jsonDecode(resp);
    print("\n\n${response.toString()}\n\n");

    setState(() {
      name  = response['data']['name'].toString();
      contact = response['data']['contact'].toString();
    });


    //
    // SharedPreferences prefs=await SharedPreferences.getInstance();
    // setState(() {
    //   name=prefs.getString("name");
    //    contact=prefs.getString("contact").toString();
    //
    // });




  }
  
  
  
  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    print("name shared =$name");
    print("contact shared =$contact");



  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 0.5 * height,
          width: width,
          color: primary_color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  child: Icon(
                    Icons.person_outline_sharp,
                    size: 40,
                  ),
                ),
              ),
              Text(
                name==""?"Test_user":name.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                contact==""?"111111111":contact.toString(),
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Card(
          elevation: 5,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => EditProfileScreen(newUser:false)));
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
              SharedPreferences prefs= await SharedPreferences.getInstance();
              prefs.clear();
              print("token cleared");
              print(prefs.getString("token"));
              Navigator.pop(context);
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => SignUpScreen(
                          )));
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
        )
      ],
    )
    );
  }
}
