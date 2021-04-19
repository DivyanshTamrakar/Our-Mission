import 'dart:convert';

import 'package:aws_translate/aws_translate.dart';
import 'package:flutter/material.dart';
import 'package:namma_badavane/models/complaint_model.dart';
import 'package:namma_badavane/utils/HttpResponse.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import '../config.dart';
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
      file = "",
      language = "",
  titleKn="",statusKn="",descriptionKn="",departmentKn="",subdepartmentKn="" ;

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

      print("language before aws function call ========$language");
      if(language != "English")
      {
        getaws();
      }
    });
  }

  getaws() async{
    AwsTranslate awsTranslate = AwsTranslate(
      poolId: poolId, // your pool id here
      region: region,
    ); // your region here


    String translated1 = await awsTranslate.translateText(title, to: 'kn');
    String translated2 = await awsTranslate.translateText(description, to: 'kn');
    String translated3 = await awsTranslate.translateText(department, to: 'kn');
    String translated4 = await awsTranslate.translateText(subdepartment, to: 'kn');
    String translated5 = await awsTranslate.translateText(status, to: 'kn');
    if (!mounted) return;
    setState(() {
      titleKn = translated1.toString();
      descriptionKn = translated2.toString();
      statusKn = translated3.toString();
      departmentKn = translated4.toString();
      subdepartmentKn = translated5.toString();
    });

    print(translated1 );
    print(translated2);
    print(translated3);
    print("title");
    print("description");print("status");
    print(title);
    print(description);
    print(status);


  }

  GetPreferData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      language = pref.getString("language");
    });
    print(pref.getString("language"));
    print("language ========$language");
  }

  @override
  void initState() {
    super.initState();
    GetPreferData();
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
        backgroundColor: HomeScreen.color,
        title: Text(
            language == "English"?"Solved Complaint Details View":"ಪರಿಹರಿಸಿದ ದೂರು ವಿವರಗಳ ವೀಕ್ಷಣೆ",
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
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  "${language == "English"?"Complaint id":"ದೂರು ಐಡಿ"} : ${widget.id}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
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
                                width: width * 0.5,
                                child: Text(
                                  language == "English"?title:titleKn==""?"Please wait...":titleKn,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: width * 0.18,
                                child: Icon(
                                  Icons.assignment_turned_in_rounded,
                                  color: Colors.green,
                                  size: 40.0,
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
                          Text(
                              language == "English"?"Description":"ವಿವರಣೆ",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12)),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              language == "English"?description:descriptionKn==""?"Please wait...":descriptionKn,
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
                              "${language == "English"?"Department :-":"ಇಲಾಖೆ :-"} ${language == "English"?department:departmentKn==""?"Please wait...":departmentKn}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: width,
                            child: Text(
                              "${language == "English"?"Sub Department :-":"ಉಪ ಇಲಾಖೆ :-"} ${language == "English"?subdepartment:subdepartmentKn==""?"Please wait...":subdepartmentKn}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: width,
                            child: Text(
                              "${language == "English"?"Status :-":"ಸ್ಥಿತಿ :-"} ${language == "English"?status:statusKn==""?"Please wait...":statusKn}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
