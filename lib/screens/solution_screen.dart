import 'dart:convert';

import 'package:aws_translate/aws_translate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namma_badavane/models/complaint_model.dart';
import 'package:namma_badavane/screens/complaint_detail_screen.dart';
import 'package:namma_badavane/screens/solution_detail_screen.dart';
import 'package:namma_badavane/services/complaint_service.dart';
import 'package:namma_badavane/utils/HttpResponse.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import 'homescreen.dart';

class SolutionScreen extends StatefulWidget {
  @override
  _SolutionScreenState createState() => _SolutionScreenState();
}

class _SolutionScreenState extends State<SolutionScreen> {
  List<dynamic> solution = [];
  String language = "";
  List<dynamic> title_kann=[];
  List<dynamic> description_kann=[];

  getSolutionData() async {
    var resp = await HttpResponse.getResponse(service: '/users/solution/all');
    print("\n\n$resp\n\n");

    var response = jsonDecode(resp);
    print("\n\n${response.toString()}\n\n");

    setState(() {
      solution = response['data'];

      print("solutions list");
      print(solution);
      print(solution.length);
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
    for (var i = 0; i < solution.length; i++) {
      print("inside loop");

      String translated1 = await awsTranslate
          .translateText(solution[i]['title'].toString(), to: 'kn');
      String translated2 = await awsTranslate
          .translateText(solution[i]['description'].toString(), to: 'kn');
      if (!mounted) return CircularProgressIndicator();
      setState(() {
        title_kann.add(translated1.toString());
        description_kann.add(translated2.toString());

        print("title kanana list ");
        print(title_kann);
        print("description kannada  list ");
        print(description_kann);
      });
    }

    print("title kanana list ");
    print(title_kann);
    print("descreption kanana list ");
    print(description_kann);
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
    // TODO: implement initState
    super.initState();
    GetPreferData();
    getSolutionData();

  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  HomeScreen.color,
        title: Text(
          language == "English"?"Solved Complaints":"ಪರಿಹರಿಸಿದ ದೂರುಗಳು",
          style: TextStyle(
            color: primary_text_color,
          ),
        ),
        centerTitle: true,
      ),
      body: (solution != null)
          ? (solution.length > 0)
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [

                    Expanded(
                      child: ListView.builder(
                          itemCount: solution.length,
                          itemBuilder: (context, i) {
                              return Container(
                              margin: EdgeInsets.all(5),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: Colors.grey[300], width: 1.0),
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(4.0),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                SoutionDetailScreen(
                                                    id: solution[i]['_id'])));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 15,
                                        bottom: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: width * 0.5,
                                              child: Text(
                                                language == "English" ? solution[i]['title']:(title_kann.length > i      ? title_kann[i]  : 'Please wait...'),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            // Spacer(),
                                            Text(
                                              language == "English"?"Complain Id:":"ಐಡಿ ದೂರು : ",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,
                                            ),
                                            Container(
                                              width: width * 0.2,
                                              child: Text(
                                                solution[i]['_id'] == null
                                                    ? "123"
                                                    : solution[i]['_id'],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(height: 20,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Divider(
                                            height: 1,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        Text(
                                          language == "English" ? solution[i]['description']:(description_kann.length > i      ? description_kann[i]  : 'Please wait...'),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                )
              : Center(child: Text(language == "English"?"No complaint Solution Found":"ಯಾವುದೇ ದೂರು ಪರಿಹಾರ ಕಂಡುಬಂದಿಲ್ಲ",textAlign: TextAlign.center),)
          : Center(child: Text("No complaint Solution Found",textAlign: TextAlign.center)),
    );
  }
}
