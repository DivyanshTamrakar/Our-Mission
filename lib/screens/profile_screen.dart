import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namma_badavane/models/user_model.dart';
import 'package:namma_badavane/screens/complaint_form_screen.dart';
import 'package:namma_badavane/screens/edit_profile_screen.dart';
import 'package:namma_badavane/screens/sign_up_screen.dart';
import 'package:namma_badavane/services/auth_service.dart';
import 'package:namma_badavane/utils/HttpResponse.dart';
import 'package:namma_badavane/utils/bottom_navigation.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:namma_badavane/screens/language_screen.dart';

import '../config.dart';
import 'homescreen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name="",contact="",profile="",language="";

  GetPreferData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      language = pref.getString("language");
    });
    print(pref.getString("language"));
    print("language ========$language");
  }

  getUserData()async{

    var resp = await HttpResponse.getResponse(
        service: '/users/profile',);
    print("\n\n$resp\n\n");

    var response = jsonDecode(resp);
    print("\n\n${response.toString()}\n\n");

    setState(() {
      name  = response['data']['name'].toString();
      contact = response['data']['contact'].toString();
      profile = response['data']['profile'].toString();

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
    GetPreferData();
    // print("name shared =$name");
    // print("contact shared =$contact");



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
          color: HomeScreen.color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    // BoxShadow(
                    //   color: Colors.green,
                    //   blurRadius: 10.0,
                    //   offset: Offset(0, 5),
                    //   spreadRadius: 1.0,
                    // ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: profile == null ?Image.asset(
                    "assets/profile_placeholder.png",
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ):Image.network(profile,height: 120,width: 120,fit: BoxFit.cover,),
                ),
              ),
              SizedBox(height:20),
              Text(
                name==""?"Test_user":name.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: button_text_color,
                ),
              ),
              SizedBox(height: 10),
              Text(
                contact==""?"111111111":contact.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: button_text_color,
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
                language == "English"?"Edit Profile":"ಪ್ರೊಫೈಲ್ ಬದಲಿಸು",
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
            onTap: () {
              print("clicked");
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) => Language_selection(),
              );
              //     .then((value){
              //   Navigator.pop(context);
              //   Navigator.push(
              //       context,
              //       CupertinoPageRoute(
              //           builder: (context) => BottomBarExample()));
              // } );

            },
            child: ListTile(
              leading: Icon(Icons.edit, color: button_color),
              title: Text(
                language == "English"?"Change Language":"ಭಾಷೆ ಬದಲಾಯಿಸಿ",
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
              print("language cleared");
              print(prefs.getString("language"));
              Navigator.pop(context);
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => LoginScreen(
                          )));
            },
            child: ListTile(
              leading: Icon(Icons.logout, color: button_color),
              title: Text(
                language == "English"?"Log out":"ಲಾಗ್ ಔಟ್",
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
