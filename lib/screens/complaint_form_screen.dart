import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namma_badavane/config.dart';
import 'package:namma_badavane/models/complaint_model.dart';
import 'package:namma_badavane/models/department_model.dart';
import 'package:namma_badavane/screens/submitted_screen.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:namma_badavane/widgets/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

import 'homescreen.dart';

class ComplaintFormScreen extends StatefulWidget {
  final List<Department> departments;
  final String subDepartment;
  final File image;
  final int departmentNumber;

  ComplaintFormScreen(
      {Key key,
      this.departments,
      this.subDepartment,
      this.image,
      this.departmentNumber})
      : super(key: key);

  @override
  _ComplaintFormScreenState createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  List<String> subDepartments;
  Department _selectedDepartment;
  String _selectedSubDepartment, contact = "", email = "", location = "";
  Complaint complaint = new Complaint();
  String lat = "";
  String lan = "";


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
      lat = "${geoposition.latitude}";
      lan = "${geoposition.longitude}";
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      contact = prefs.getString('contact');
      email = prefs.getString('email');
      location = prefs.getString('location');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDepartment = widget.departments[widget.departmentNumber];
    _selectedSubDepartment = widget.subDepartment;
    subDepartments = _selectedDepartment.subDepartment;
    getData();
    getCurrenLocation();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HomeScreen.color,
        title: Text("Complaint/Issue Detail",
            style: TextStyle(color: primary_text_color)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Material(
                elevation: 10,
                child: Container(
                    width: width,
                    height: 200,
                    color: Colors.transparent,
                    child: Image.file(
                      widget.image,
                      fit: BoxFit.fill,
                    )),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Card(
                      elevation: 5,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            complaint.title = value;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[500], width: 1.0),
                          ),
                          hintText: 'Enter Complaint title',
                          suffixIcon: Container(
                            width: width * 0.08,
                            // color: Colors.pink,
                            child: Center(
                              child: Container(
                                width: width * 0.08,
                                // color: Colors.pink,
                                child: Center(
                                  child: Text(
                                    "*",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                          side: new BorderSide(
                              color: Colors.grey[500], width: 1.0),
                          borderRadius: BorderRadius.circular(4.0)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("Enter Complaint Details/Desc"),
                                Spacer(),
                                Container(
                                  width: width * 0.08,
                                  // color: Colors.pink,
                                  child: Center(
                                    child: Text(
                                      "*",
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  complaint.description = value;
                                });
                              },
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              //Normal textInputField will be displayed
                              maxLines: 5,
                              // when user presses enter it will adapt to it
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey[500], width: 1.0),
                                ),
                                // hintText: 'Enter Complaint Details/Desc',
                                //   suffixIcon:Text("*", style:
                                //   TextStyle(
                                //     fontSize: 25,
                                //     color: Colors.red,
                                //   ),
                                //     textAlign: TextAlign.center,),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      elevation: 5,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            complaint.contact = int.parse(value);
                          });
                        },
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[500], width: 1.0),
                          ),
                          hintText: 'Enter Contact Number',
                          suffixIcon: Container(
                            width: width * 0.08,
                            // color: Colors.pink,
                            child: Center(
                              child: Text(
                                "*",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      elevation: 5,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            complaint.email = value;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[500], width: 1.0),
                          ),
                          hintText: 'Enter Email Id',
                          suffixIcon: Container(
                            width: width * 0.08,
                            // color: Colors.pink,
                            child: Center(
                              child: Text(
                                "*",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.my_location_outlined),
                        SizedBox(width: 3),
                        Text("Location is Automatically Detected"),
                      ],
                    ),
                    SizedBox(height: 10),
                    Card(
                      elevation: 5,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            complaint.location =
                                Location(coordinates: [11.2, 11.3]);
                          });
                        },
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[500], width: 1.0),
                          ),
                          hintText: 'Enter Location',
                          suffixIcon: Container(
                            width: width * 0.08,
                            // color: Colors.pink,
                            child: Center(
                              child: Text(
                                "*",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                          side: new BorderSide(
                              color: Colors.grey[500], width: 1.0),
                          borderRadius: BorderRadius.circular(4.0)),
                      elevation: 5,
                      child: Container(
                        width:  width,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: widget.departments[widget.departmentNumber].title,
                        ),
                      ),
                      // Drop Down for departments done by karanpreet.
                      // child: Container(
                      //   width: width,
                      //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(5.0),
                      //   ),
                      //   child: DropdownButtonHideUnderline(
                      //     child: DropdownButton(
                      //       hint: Text('Select department'),
                      //       items: widget.departments
                      //           .map((item) => DropdownMenuItem(
                      //               child: new Text(item.title), value: item))
                      //           .toList(),
                      //       value: _selectedDepartment,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           complaint.department = value.title;
                      //           print(value.toString());
                      //           _selectedDepartment = value;
                      //           _selectedSubDepartment = null;
                      //           subDepartments = value.subDepartment;
                      //           // _selectedSubDepartment = subDepartments[0];
                      //         });
                      //       },
                      //     ),
                      //   ),
                      // ),
                    ),
                    SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                      side: new BorderSide(
                          color: Colors.grey[500], width: 1.0),
                      borderRadius: BorderRadius.circular(4.0)),
                  elevation: 5,
                  child: Container(
                    width:  width,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),),
                    child: TextFormField(
                      readOnly: true,
                      initialValue: _selectedSubDepartment,
                    ),
                  ),),
                            // Sub department drop down done by karan preet.
                    // Card(
                    //   shape: RoundedRectangleBorder(
                    //       side: new BorderSide(
                    //           color: Colors.grey[500], width: 1.0),
                    //       borderRadius: BorderRadius.circular(4.0)),
                    //   elevation: 5,
                    //   child: Container(
                    //     width: width,
                    //     padding: EdgeInsets.symmetric(horizontal: 10.0),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(5.0),
                    //     ),
                    //     child: DropdownButtonHideUnderline(
                    //       child: DropdownButton(
                    //         hint: Text('Select Type of Service'),
                    //         items: subDepartments.map((
                    //           item,
                    //         ) {
                    //           return DropdownMenuItem(
                    //               child: Container(
                    //                   width: width * 0.8,
                    //                   child: new Text(item)),
                    //               value: item);
                    //         }).toList(),
                    //         value: _selectedSubDepartment,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             complaint.subDepartment = value;
                    //             _selectedSubDepartment = value;
                    //           });
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                          side: new BorderSide(
                              color: Colors.grey[500], width: 1.0),
                          borderRadius: BorderRadius.circular(4.0)),
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          width: width,
                          child: Row(
                            children: [
                              Text("${selectedDate.toLocal().toString()}"
                                  .split(' ')[0]),
                              Spacer(),
                              Icon(Icons.calendar_today)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20.0),
                      child: InkWell(
                        onTap: () async {
                          showLoaderDialog(context);
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if (_formKey.currentState.validate()) {
                            try {
                              String url = BASE_URL + "/complain/register";
                              Dio dio = new Dio();
                              dio.options.connectTimeout = 5000; //5s
                              dio.options.receiveTimeout = 3000;
                              File img = widget.image;
                              String filename = img.path.split('/').last;
                              var formdata = new FormData.fromMap({
                                "title": complaint.title,
                                "description": complaint.description,
                                "email": complaint.email,
                                "contact": complaint.contact,
                                "file": await MultipartFile.fromFile(img.path,
                                    filename: filename,
                                    contentType: new MediaType('image', 'jpeg')),
                                "department": widget.departments[widget.departmentNumber].title,
                                "sub_department": _selectedSubDepartment,
                                "location": {
                                  "coordinates":[lat, lan]
                                },
                              });
                              var response = await dio.post(url,
                                  data: formdata,
                                  options: Options(headers: {
                                    "Authorization": prefs.getString("token"),
                                     // "Authorization": token,
                                  }));
                              print(response);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(builder: (context) => SubmittedScreen()));
                            } catch (e) {
                              Navigator.pop(context);
                              print(e.toString());
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return oneButtonDialog(
                                        context: context,
                                        title: "Network Error",
                                        content:e.toString(),
                                        actionTitle: "OK");
                                  });
                            }
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          decoration: BoxDecoration(
                              color: HomeScreen.button_back ,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  'Submit',
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
                    SizedBox(height: 40),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
