import 'dart:io';
import 'package:aws_translate/aws_translate.dart';
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
import 'package:date_format/date_format.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import 'homescreen.dart';

class ComplaintFormScreen extends StatefulWidget {
  final List<Department> departments;
  final String subDepartment;

  // final File image;
  final int departmentNumber;

  ComplaintFormScreen(
      {Key key,
      this.departments,
      this.subDepartment,
      // this.image,
      this.departmentNumber})
      : super(key: key);

  @override
  _ComplaintFormScreenState createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String _setTime;
  TextEditingController _timeController = TextEditingController();
  String _hour, _minute, _time;
  String dateTime;
  final _formKey = GlobalKey<FormState>();
  List<String> subDepartments;
  Department _selectedDepartment;
  String _selectedSubDepartment, contact = "", email = "", location = "";
  Complaint complaint = new Complaint();
  String lat = "";
  String lan = "";
  String language = "";
  File image;
  String dep_kn = "";
  String sub_dep_kn = "";
  bool location_detected = false;

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Please wait...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  getCurrenLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = "${geoposition.latitude}";
      lan = "${geoposition.longitude}";
      location_detected = true;
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      contact = prefs.getString('contact');
      email = prefs.getString('email');
      location = prefs.getString('location');
      language = prefs.getString('language');
    });
    print("language before aws function call ========$language");


    if(language != "English")
    {
      getaws();
    }
  }

  getaws() async {
    AwsTranslate awsTranslate = AwsTranslate(
      poolId: poolId, // your pool id here
      region: region,
    ); // your region here

    print("outside loop");

    String translated1 = await awsTranslate.translateText(
        widget.departments[widget.departmentNumber].title.toString(),
        to: 'kn');
    String translated2 = await awsTranslate
        .translateText(_selectedSubDepartment.toString(), to: 'kn');
    if (!mounted) return CircularProgressIndicator();
    setState(() {
      dep_kn = translated1.toString();
      sub_dep_kn = translated2.toString();
    });

    print("dep_knn ");
    print(dep_kn);
    print("sub_dep_kn");
    print(sub_dep_kn);
  }

  _imgFromCamera() async {
    image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    print(image);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    _selectedDepartment = widget.departments[widget.departmentNumber];
    _selectedSubDepartment = widget.subDepartment;
    subDepartments = _selectedDepartment.subDepartment;
    getData();
    // getCurrenLocation();

  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(67, 88, 185, 1.0),
        title: Text(
            language == "English"
                ? "Complaint/Issue Detail"
                : "ದೂರು / ಸಂಚಿಕೆ ವಿವರ",
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
                  child: image == null
                      ? Image.asset(
                          'assets/placeholder_image.png',
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          image,
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                  // widget.image,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 52.0,
                  height: 52.0,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30.0),
                        border:
                            Border.all(width: 2.0, color: HomeScreen.color)),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.camera_alt_outlined),
                          color: HomeScreen.color,
                          iconSize: 25.0,
                          onPressed: () async {
                            var image_picker = await ImagePicker.pickImage(
                                source: ImageSource.camera, imageQuality: 50);
                            if (image_picker != null) {
                              setState(() {
                                image = image_picker;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
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
                          hintText: language == "English"
                              ? 'Enter Complaint title'
                              : 'ದೂರು ಶೀರ್ಷಿಕೆಯನ್ನು ನಮೂದಿಸಿ',
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
                                Text(language == "English"
                                    ? "Enter Complaint Details/Desc"
                                    : "ದೂರು ವಿವರಗಳನ್ನು ನಮೂದಿಸಿ / ಡೆಸ್ಕ್"),
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
                          hintText: language == "English"
                              ? 'Enter Contact Number'
                              : 'ಸಂಪರ್ಕ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
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
                          hintText: language == "English"
                              ? 'Enter Email Id'
                              : 'ಇಮೇಲ್ ಐಡಿ ನಮೂದಿಸಿ',
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
                    // SizedBox(height: 10),
                    // Row(
                    //   children: [
                    //     Icon(Icons.my_location_outlined),
                    //     SizedBox(width: 3),
                    //     Text("Location is Automatically Detected"),
                    //   ],
                    // ),
                    SizedBox(height: 10),
                    location_detected == true
                        ? Row(
                            children: [
                              Icon(
                                Icons.my_location_outlined,
                                color: Colors.green,
                              ),
                              SizedBox(width: 3),
                              Text(
                                language == "English" ? "Location Detected Successfull!":"ಸ್ಥಳ ಪತ್ತೆಯಾಗಿದೆ ಯಶಸ್ವಿಯಾಗಿದೆ!",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        getCurrenLocation();
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            side: new BorderSide(
                                color: Colors.grey[500], width: 1.0),
                            borderRadius: BorderRadius.circular(4.0)),
                        color: Color.fromRGBO(67, 88, 185, 1.0),
                        elevation: 5,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.my_location_outlined,
                                color: Colors.white,
                              ),
                              SizedBox(width: 3),
                              Text(
                                language == "English"
                                    ? "Detect Location"
                                    : "ಸ್ಥಳವನ್ನು ಪತ್ತೆ ಮಾಡಿ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
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
                          hintText: language == "English"
                              ? 'Enter Location'
                              : 'ಸ್ಥಳವನ್ನು ನಮೂದಿಸಿ',
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
                      child: ListTile(
                        title: Text(
                          language == "English"
                              ? widget
                                  .departments[widget.departmentNumber].title
                              : dep_kn == ""
                                  ? "..."
                                  : dep_kn,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                          side: new BorderSide(
                              color: Colors.grey[500], width: 1.0),
                          borderRadius: BorderRadius.circular(4.0)),
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          language == "English"
                              ? _selectedSubDepartment
                              : sub_dep_kn == ""
                                  ? "..."
                                  : sub_dep_kn,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

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
                    SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                          side: new BorderSide(
                              color: Colors.grey[500], width: 1.0),
                          borderRadius: BorderRadius.circular(4.0)),
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 4.0, left: 10.0),
                              width: width / 2,
                              child: TextFormField(
                                // style: TextStyle(fontSize: 40),
                                textAlign: TextAlign.left,
                                onSaved: (String val) {
                                  _setTime = val;
                                },
                                enabled: false,
                                // keyboardType: TextInputType.text,
                                controller: _timeController,
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(right: 15.0),
                                child: Icon(Icons.access_time))
                          ],
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
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          if (_formKey.currentState.validate()) {
                            try {
                              String url = BASE_URL + "/complain/register";
                              Dio dio = new Dio();
                              dio.options.connectTimeout = 5000; //5s
                              dio.options.receiveTimeout = 3000;
                              File img = image == null
                                  ? await getImageFileFromAssets(
                                      'placeholder_image.png')
                                  : image;

                              // print("img === $img");
                              // print("image === $image");
                              // print("title === ${complaint.title}");
                              // print("description === ${complaint.description}");
                              // print("eamil === ${complaint.email}");
                              // print("contact === ${complaint.contact}");
                              // print(
                              //     "department === ${widget.departments[widget.departmentNumber].title}");
                              // print(
                              //     "subdepartment === ${_selectedSubDepartment}");
                              // print("file === $image");

                              String filename = img.path.split('/').last;
                              var formdata = new FormData.fromMap({
                                "title": complaint.title,
                                "description": complaint.description,
                                "email": complaint.email,
                                "contact": complaint.contact,
                                "file": await MultipartFile.fromFile(img.path,
                                    filename: filename,
                                    contentType:
                                        new MediaType('image', 'jpeg')),
                                "department": widget
                                    .departments[widget.departmentNumber].title,
                                "sub_department": _selectedSubDepartment,
                                "location": {
                                  "coordinates": [lat, lan]
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
                                  CupertinoPageRoute(
                                      builder: (context) => SubmittedScreen()));
                            } catch (e) {
                              Navigator.pop(context);
                              print(e.toString());
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return oneButtonDialog(
                                        context: context,
                                        title: "Network Error",
                                        content: "Something went Wrong",
                                        actionTitle: "OK");
                                  });
                            }
                          } else {
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
                              color: HomeScreen.button_back,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  language == "English" ? 'Submit' : 'ಸಲ್ಲಿಸು',
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
