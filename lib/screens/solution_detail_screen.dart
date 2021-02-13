import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:namma_badavane/models/complaint_model.dart';
import 'package:namma_badavane/utils/HttpResponse.dart';
import 'package:namma_badavane/utils/colors.dart';

import 'homescreen.dart';

class SoutionDetailScreen extends StatefulWidget {
  final id;

  SoutionDetailScreen({Key key, this.id}) : super(key: key);

  @override
  _SoutionDetailScreenState createState() => _SoutionDetailScreenState();
}

class _SoutionDetailScreenState extends State<SoutionDetailScreen> {
  String title = "",
      date = "",
      description = "",
      department = "",
      subdepartment = "",
      status = "",
      file="";

  getSolutionDataDetail() async {
    var resp =
        await HttpResponse.getResponse(service: '/solution/${widget.id}');
    print("\n\n$resp\n\n");

    var response = jsonDecode(resp);
    print("\n\n${response.toString()}\n\n");

    setState(() {
      title = response['data']['title'];
      date = response['data']['date_of_solution'];
      description = response['data']['description'];
      department = response['data']['department'];
      subdepartment = response['data']['sub_department'];
      status = response['data']['status'];
      file = response['data']['file'];
    });
  }

  @override
  void initState() {
    super.initState();
    getSolutionDataDetail();
    print("Solution data");
    print("${widget.id}");
  }

  @override
  Widget build(BuildContext context) {
    // var date = DateTime.parse(widget.complaint.dateOfComplain);
    // var formattedDate = "${date.day}-${date.month}-${date.year}";
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  HomeScreen.color,
        title: Text("Solved Complaint Details View",
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
                    // image: 'assets/placeholder_image.png',
                    image: '$file',
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
                                  title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: width * 0.18,
                                child: Icon(Icons.assignment_turned_in_rounded,color: Colors.green,size: 40.0,),
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
                              description,
                              style: TextStyle(),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Divider(
                            height: 1,
                            color: Colors.green,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            width: width,
                            child: Text(
                              "Department :- $department",
                              textAlign: TextAlign.left,
                              style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: width,
                            child: Text(
                              "Sub Department :- $subdepartment",
                              textAlign: TextAlign.left,
                              style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: width,
                            child: Text(
                              "Status :- ${status}",
                              textAlign: TextAlign.left,
                              style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10),

                        ],
                      ),
                    ),
                  ),


                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
