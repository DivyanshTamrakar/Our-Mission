import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:namma_badavane/config.dart';
import 'package:namma_badavane/models/complaint_model.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:namma_badavane/widgets/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homescreen.dart';

class ComplaintDetailScreen extends StatefulWidget {
  final Complaint complaint;
   // final id ;
  ComplaintDetailScreen({Key key, this.complaint}) : super(key: key);

  @override
  _ComplaintDetailScreenState createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends State<ComplaintDetailScreen> {
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    print("Complaint data");
    // print("${widget.id.status}");
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.parse(widget.complaint.dateOfComplain);
    var formattedDate = "${date.day}-${date.month}-${date.year}";
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                elevation: 10,
                child: Container(
                  width: width,
                  height: 200,
                  color: Colors.transparent,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder_image.png',
                    image: "${widget.complaint.file}",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(height: 1, indent: 20, endIndent: 20),
              SizedBox(height: 10),
              Column(
                children: [
                  SizedBox(height: 10),
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: width * 0.7,
                                child: Text(
                                  widget.complaint.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: width * 0.18,
                                child: Text(
                                  formattedDate,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(
                            height: 1,
                            color: Colors.black38,
                          ),
                          SizedBox(height: 10),
                          Text("Description",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12)),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              widget.complaint.description,
                              style: TextStyle(),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.call,
                                              color: Colors.green, size: 14),
                                          SizedBox(width: 5),
                                          Text("Contact no -"),
                                          SizedBox(width: 5),
                                          Text(widget.complaint.contact
                                              .toString()),
                                        ]),
                                    SizedBox(height: 10),
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.alternate_email_outlined,
                                              color: Colors.green, size: 14),
                                          SizedBox(width: 5),
                                          Text("Email Id -"),
                                          SizedBox(width: 5),
                                          Text(widget.complaint.email),
                                        ]),
                                    SizedBox(height: 10),
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.call,
                                              color: Colors.green, size: 14),
                                          SizedBox(width: 5),
                                          Text("Status -"),
                                          SizedBox(width: 5),
                                          // Text("Submitted"),
                                          Text(widget.complaint.status),
                                        ]),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              Container(
                                height: 70,
                                width: 70,
                                color: Colors.transparent,
                                child: widget.complaint.status == "Processing"
                                    ? Icon(
                                        Icons.pending_actions_rounded,
                                        size: 70.0,
                                        color: Colors.deepOrange,
                                      )
                                    : Icon(
                                        Icons.assignment_turned_in_rounded,
                                        size: 70.0,
                                        color: Colors.green,
                                      ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.green,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: width,
                    child: Text(
                      "Provide Feedback to Us !",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 5,
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: _controller,
                      minLines: 5,
                      maxLines: 6,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[200], width: 2.0),
                        ),
                        hintText:
                            'Feel free to provide your feedback over here !',
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
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (_controller.text.toString() == "") {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return oneButtonDialog(
                                    context: context,
                                    title: "Feedback Can't be Empty",
                                    content: "Feedback must be filled",
                                    actionTitle: "OK");
                              });
                        } else {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          var headers = {
                            // "Authorization":  prefs.getString("token"),
                            "Authorization": token,
                            "Content-Type": "application/json",

                          };
                          print(headers);
                          print(_controller.text.toString());
                          var map = new Map<String, dynamic>();
                          map["description"] = _controller.text.toString();
                          map['rating'] = "4";
                          print("Params Feedback Data " + map.toString());
                          print("map + $map");
                          final msg  = jsonEncode(map);
                          print(msg);
                          final resp = http
                              .post("${BASE_URL}/feedback/new-feedback",
                                  body: msg, headers: headers)
                              .then((http.Response response) {
                            if (response.statusCode < 200 ||
                                response.statusCode > 400 ||
                                json == null) {
                              print(
                                  'HttpResponse==' + response.body.toString());
                              throw new Exception(
                                  "Error while fetching============================");
                            }
                            print(response.body.toString());

                            Map<String, dynamic> data =
                                jsonDecode(response.body);

                            print("Divyansh + $data"); // divyansh

                            if (data['status'] == "201") {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return oneButtonDialog(
                                      context: context,
                                      title: "Successfull",
                                      content: "Your record has been recorded!",
                                      actionTitle: "OK",
                                    );
                                  });
                            }
                          });
                          Navigator.pop(context);
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
                                'Submit Feedback',
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
                              Icons.format_align_justify,
                              color: button_icon_color,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
