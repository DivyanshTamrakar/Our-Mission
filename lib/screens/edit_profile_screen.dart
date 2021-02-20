import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namma_badavane/config.dart';
import 'package:namma_badavane/screens/homescreen.dart';
import 'package:namma_badavane/utils/bottom_navigation.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:namma_badavane/widgets/dialogs.dart';
import 'package:namma_badavane/utils/HttpResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final bool newUser;

  EditProfileScreen({Key key, this.newUser}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _name = "", _email = "", _location = "", _area = "",profile_image = "";

  List<bool> hasError = [false, false, false, false];
  String usertoken;

  String latitude = "";
  String longitude = "";
  File image;

  getUserData()async{

    var resp = await HttpResponse.getResponse(
      service: '/users/profile',);
    print("\n\n$resp\n\n");

    var response = jsonDecode(resp);
    print("\n\n${response.toString()}\n\n");

    setState(() {
      profile_image = response['data']['profile'].toString();

    });
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Please wait..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
  getCurrenLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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
    // getUserData();
    print("Bool widget.newUser == ${widget.newUser}");
    print(widget.newUser);
    print(" Nitesh token");
    print(token);
    print(" My Token");
    getToken().then((value) => {print(value), usertoken = value});
    print(usertoken);
    if (!widget.newUser) getData();
  }

  @override
  Widget build(BuildContext context) {
    // print(hasError);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: HomeScreen.color),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      // BoxShadow(
                      //   color: Colors.grey,
                      //   blurRadius: 10.0,
                      //   offset: Offset(0, 5),
                      //   spreadRadius: 1.0,
                      // ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: image == null? Image.asset(
                      "assets/profile_placeholder.png",
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ):
                    Image.file(
                         image,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                    )
                  ),
                ),
                Positioned(
                  bottom: 1,
                  right: 15,
                  child: GestureDetector(
                    onTap: () async {
                      var image_picker = await ImagePicker.pickImage(
                          source: ImageSource.camera, imageQuality: 50);
                      if (image_picker != null) {
                        setState(() {
                          image = image_picker;
                        });
                      }
                    },
                    child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HomeScreen.color,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        )),
                  ),
                )
              ],
            ),
            // GestureDetector(
            //   onTap: () async {
            //     // SharedPreferences prefs = await SharedPreferences
            //     //     .getInstance();
            //     // Dio dio = new Dio();
            //     // dio.options.connectTimeout = 5000; //5s
            //     // dio.options.receiveTimeout = 3000;
            //     //
            //     // var image_picker = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality:50);
            //     // if(image_picker != null){
            //     //   setState(() {
            //     //     image = image_picker;
            //     //   });
            //     // }
            //     // try{
            //     //   String user_url = BASE_URL + "/users/profile-update";
            //     //   String filename  = image.path.split('/').last;
            //     //   var formData = new FormData.fromMap({
            //     //     "name":"Nitesh Vishwakarma",
            //     //     "email":"tx2terminator@gmail.com",
            //     //     "address":"sfdlsdfjg",
            //     //     "location":[latitude,longitude],
            //     //     "profile": await MultipartFile.fromFile(image.path,filename:filename, contentType: new MediaType('image','jpeg') ),
            //     //   });
            //     //   print("fOrm data");
            //     //   print(formData);
            //     //   var response = await dio.post(user_url, data: formData,
            //     //       options: Options(headers: {
            //     //         // "Authorization": prefs.getString("token"),
            //     //         "Authorization": token,
            //     //       })
            //     //   );
            //     //   print(response);
            //     // }catch(e){print(e);
            //     //
            //     // showDialog(
            //     //     context: context,
            //     //     builder: (BuildContext context) {
            //     //       return oneButtonDialog(
            //     //           context: context,
            //     //           title: "Error",
            //     //           content:
            //     //           e.toString(),
            //     //           actionTitle: "OK");
            //     //     });
            //     //
            //     // }
            //   },
            //   child: Container(
            //       height: height * 0.5,
            //       width: width,
            //       decoration: BoxDecoration(
            //           image: DecorationImage(
            //         fit: BoxFit.fill,
            //         image: AssetImage("assets/profile_details_green.png"),
            //       ))),
            // ),
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
                          prefixIcon: Icon(Icons.location_on_sharp),
                          suffixIcon: Visibility(
                            visible: hasError[2],
                            child: Icon(Icons.error_outline, color: Colors.red),
                          )),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.my_location),
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
                        showLoaderDialog(context);
                        if (!(hasError[0] ||
                            hasError[1] ||
                            hasError[2] ||
                            hasError[3]))
                          try {
                            Dio dio = new Dio();
                            dio.options.connectTimeout = 5000; //5s
                            dio.options.receiveTimeout = 3000;
                            // var uniquetoken = getToken();
                            String url;
                            if (widget.newUser)
                              url = BASE_URL + "/users/profile-completion";
                            else
                              url = BASE_URL + "/users/profile-update";
                            String filename = image.path.split('/').last;
                            var formData = new FormData.fromMap({
                              "name": _name,
                              "email": _email,
                              "address": _area,
                              "location": {
                                "coordinates":[latitude, longitude],
                              },
                              "profile": await MultipartFile.fromFile(
                                  image.path,
                                  filename: filename,
                                  contentType: new MediaType('image', 'jpeg')),
                            });
                            print("profile update  === $url");
                            var response = await dio.post(url,
                                data: formData,
                                options: Options(headers: {
                                  // "Authorization": token
                                  "Authorization": usertoken
                                }));
                            print(response);
                            Navigator.pop(context);
                            if (widget.newUser)
                              Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => BottomBarExample()),
                                (route) => false,
                              );
                            else{
                              Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => BottomBarExample()),
                                    (route) => false,
                              );
                            }

                          } catch (e) {
                            Navigator.pop(context);
                            print(e.toString());
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return oneButtonDialog(
                                      context: context,
                                      title: "Network Error",
                                      content: e.toString(),
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
                            color: HomeScreen.button_back,
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
