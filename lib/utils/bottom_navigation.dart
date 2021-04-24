import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namma_badavane/screens/history_screen.dart';
import 'package:namma_badavane/screens/homescreen.dart';
import 'package:namma_badavane/screens/profile_screen.dart';
import 'package:namma_badavane/screens/solution_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomBarExample extends StatefulWidget {
  @override
  _BottomBarExampleState createState() => new _BottomBarExampleState();
}

class _BottomBarExampleState extends State<BottomBarExample> {
  File _image;
  int _page = 0;
  PageController _controller;
  String language = "";
  String label_one = "", label_two = "", label_three = "", label_four = "";

  GetPreferData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      if (pref.getString("language") != null) {
        language = pref.getString("language");
      } else {
        language = "English";
        pref.setString("language", "English");
      }
    });
    print(pref.getString("language"));
    print("language ========$language");
  }

  @override
  void initState() {
    GetPreferData();
    _controller = new PageController(
      initialPage: _page,
    );
    super.initState();
  }

  _imgFromCamera() async {
    PickedFile image = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      print("Path=======${image.path}");
      _image = File(image.path);
    });
  }

  _imgFromGallery() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      extendBody: true,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   shape: CircleBorder(),
      //   onPressed: () {
      //     _imgFromCamera();
      //   },
      //   child: CircleAvatar(
      //     radius: 22,
      //     // backgroundColor: primary_color,
      //     backgroundColor: HomeScreen.color,
      //     child: CircleAvatar(
      //       radius: 20,
      //       backgroundColor: Colors.white,
      //       child: Icon(
      //         Icons.camera_alt_outlined,
      //         // color: primary_color,
      //         color: HomeScreen.color,
      //       ),
      //     ),
      //   ),
      //   elevation: 5.0,
      // ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        notchMargin: 4,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.yellowAccent,
          // backgroundColor: primary_color,
          backgroundColor: HomeScreen.color,
          currentIndex: _page,
          onTap: (index) {
            this._controller.animateToPage(index,
                duration: const Duration(milliseconds: 10),
                curve: Curves.easeInOut);
          },
          items: language == "English"
              ? <BottomNavigationBarItem>[
                  new BottomNavigationBarItem(
                      icon: new Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      label: "Home"), //:"ಮನೆ"
                  new BottomNavigationBarItem(
                      icon: new Icon(
                        Icons.history,
                        color: Colors.white,
                      ),
                      label: "History"), //"ಇತಿಹಾಸ"
                  new BottomNavigationBarItem(
                      icon: new Icon(
                        Icons.lightbulb,
                        color: Colors.white,
                      ),
                      label: "Solutions"), //:"ಪರಿಹಾರಗಳು"
                  new BottomNavigationBarItem(
                      icon: new Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      label: "Profile"), //:"ಪ್ರೊಫೈಲ್"
                  //:"ಪ್ರೊಫೈಲ್"
                ]
              : <BottomNavigationBarItem>[
                  new BottomNavigationBarItem(
                      icon: new Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      label: "ಮನೆ"),
                  //:"ಮನೆ"
                  new BottomNavigationBarItem(
                      icon: new Icon(
                        Icons.history,
                        color: Colors.white,
                      ),
                      label: "ಇತಿಹಾಸ"),
                  //"ಇತಿಹಾಸ"
                  new BottomNavigationBarItem(
                      icon: new Icon(
                        Icons.lightbulb,
                        color: Colors.white,
                      ),
                      label: "ಪರಿಹಾರಗಳು"),
                  //:"ಪರಿಹಾರಗಳು"
                  new BottomNavigationBarItem(
                      icon: new Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      label: "ಪ್ರೊಫೈಲ್"),
                  //:"ಪ್ರೊಫೈಲ್"

                ],

          // items: <BottomNavigationBarItem>[
          //   new BottomNavigationBarItem(
          //       icon: new Icon(Icons.home,color: Colors.white,), label: "Home"),//:"ಮನೆ"
          //   new BottomNavigationBarItem(
          //       icon: new Icon(Icons.history,color: Colors.white,), label:"History"),//"ಇತಿಹಾಸ"
          //   new BottomNavigationBarItem(
          //       icon: new Icon(Icons.lightbulb,color: Colors.white,), label: "Solutions"),//:"ಪರಿಹಾರಗಳು"
          //   new BottomNavigationBarItem(
          //       icon: new Icon(Icons.person,color: Colors.white,), label: "Profile"),//:"ಪ್ರೊಫೈಲ್"
          // ],
        ),
      ),
      body: new PageView(
        controller: _controller,
        onPageChanged: (newPage) {
          setState(() {
            this._page = newPage;
          });
        },
        children: <Widget>[
          HomeScreen(),
          HistoryScreen(),
          SolutionScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
