import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namma_badavane/config.dart';
import 'package:namma_badavane/utils/bottom_navigation.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:namma_badavane/widgets/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final bool newUser;

  EditProfileScreen({Key key, this.newUser}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _name = "", _email = "", _location = "", _area = "";
  List<bool> hasError = [false, false, false, false];
  String usertoken ;
  String latitude = "";
  String longitude = "";
  File image;

  getCurrenLocation() async {
    final geoposition  = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = "${geoposition.latitude}";
      longitude = "${geoposition.longitude}";

    });
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("name");
      _email = prefs.getString("email");
      _area = prefs.getString("area");
      _location = prefs.getString("location");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrenLocation();
    print("Bool widget.newUser == ${widget.newUser}");
    print(widget.newUser);
    print(" Nitesh token");
    print(token);
    print(" My Token");
    getToken().then((value) =>  {
    print(value),
      usertoken = value
     });
    print(usertoken);
    if (!widget.newUser) getData();
  }

  @override
  Widget build(BuildContext context) {
    // print(hasError);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                var dio = new Dio();
                var image_picker = await ImagePicker.pickImage(source: ImageSource.camera);
                if(image_picker != null){
                  setState(() {
                    image = image_picker;
                  });
                }
                try{
                  String user_url = BASE_URL + "/users/profile-update";
                  String filename  = image.path.split('/').last;
                  FormData formdata = new FormData.fromMap({
                    "profile": await MultipartFile.fromFile(image.path,filename: filename,
                    contentType: new MediaType('image','png')),
                    "type":"image/png"
                  });
                  Response response = await dio.post(user_url,
                      data: formdata,
                      options: Options(headers: {
                        // "Authorization": token
                        "accept":"*/*",
                        "Authorization": token,
                        "Content-Type":"multipart/form-data"
                      }));
                  print(response);



                }catch(e){print(e);
                }

              },
              child: Container(
                  height: height * 0.5,
                  width: width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/profile_details_green.png"),
                  ))),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Container(
                    width: width,
                    child: Text(
                      (widget.newUser == false)
                          ? "Edit your Profile"
                          : "Complete your Profile",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 5,
                    child: TextFormField(
                      initialValue: _name,
                      onChanged: (text) {
                        setState(() {
                          _name = text;
                          hasError[0] = false;
                          if (text.isEmpty) hasError[0] = true;
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[500], width: 1.0),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                        suffixIcon: Visibility(
                            visible: hasError[0],
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 5,
                    child: TextFormField(
                      initialValue: _email,
                      onChanged: (text) {
                        setState(() {
                          _email = text;
                          hasError[1] = false;
                          if (text.isEmpty) hasError[1] = true;
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[500], width: 1.0),
                            borderRadius: BorderRadius.circular(10)),
                        suffixIcon: Visibility(
                            visible: hasError[1],
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            )),
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.alternate_email),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 5,
                    child: TextFormField(
                      initialValue: _area,
                      onChanged: (text) {
                        setState(() {
                          _area = text;
                          hasError[2] = false;
                          if (text.isEmpty) hasError[2] = true;
                        });
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey[500], width: 1.0),
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Area/Locality',
                          prefixIcon: Icon(Icons.map_sharp),
                          suffixIcon: Visibility(
                            visible: hasError[2],
                            child: Icon(Icons.error_outline, color: Colors.red),
                          )),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.map_sharp),
                      SizedBox(width: 3),
                      Text("Location is Automatically Detected"),
                      // Text(latitude),
                      // Text(longitude),
                    ],
                  ),
                  SizedBox(height: 10),
                  Material(
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 5,
                    child: TextFormField(
                      initialValue: _location,
                      onChanged: (text) {
                        setState(() {
                          _location = text;
                          hasError[3] = false;
                          if (text.isEmpty) hasError[3] = true;
                        });
                      },
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[500], width: 1.0),
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: 'Enter Location',
                        suffixIcon: Visibility(
                            visible: hasError[3],
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            )),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20.0),
                    child: InkWell(
                      onTap: () async {
                        if (!(hasError[0] ||
                            hasError[1] ||
                            hasError[2] ||
                            hasError[3]))
                          try {
                            var dio = new Dio();

                            // var uniquetoken = getToken();
                            String url;
                            if (widget.newUser)
                              url = BASE_URL + "/users/profile-completion";
                            else
                              url = BASE_URL + "/users/profile-update";
                            FormData formData = new FormData.fromMap({
                              "name": _name,
                              "email": _email,
                              // "profile": await MultipartFile.fromFile("././assets/splash_icon.png",filename: "profile.png"),
                              "address": _area,
                              "location": [latitude,longitude],
                            });
                            print("profile update  === $url");
                            var response = await dio.post(url,
                                data: formData,
                                options: new Options(headers: {
                                  // "Authorization": token
                                  "Authorization": usertoken
                                }));
                            print(response);
                            if (widget.newUser)
                              Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => BottomBarExample()),
                                (route) => false,
                              );
                            else
                              Navigator.pop(context);
                          } catch (e) {
                            print(e.toString());
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return oneButtonDialog(
                                      context: context,
                                      title: "Network Error",
                                      content:
                                          "Please check your internet connection",
                                      actionTitle: "OK");
                                });
                          }
                        else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return oneButtonDialog(
                                    context: context,
                                    title: "Details Error",
                                    content: "Please enter all details",
                                    actionTitle: "OK");
                              });
                        }
                      },
                      child: Container(
                        width: width * 0.8,
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                            color: button_color,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                widget.newUser == false ? 'Save' : 'Continue',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: button_text_color,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.check_circle_outline_sharp,
                              color: button_icon_color,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
