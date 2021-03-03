import 'package:aws_translate/aws_translate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namma_badavane/models/complaint_model.dart';
import 'package:namma_badavane/screens/complaint_detail_screen.dart';
import 'package:namma_badavane/screens/homescreen.dart';
import 'package:namma_badavane/services/complaint_service.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import '../config.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Complaint> complaints = [];
  List<dynamic> title_kann = [];
  List<dynamic> description_kann = [];
  String language = "";
  String title1 = "";
  String titleKn = "";

  fetchData() async {
    var data = await ComplaintApi().getAllComplaints();
    setState(() {
      complaints = data;

      getaws();
    });
  }

  getaws() async {
    AwsTranslate awsTranslate = AwsTranslate(
      poolId: poolId, // your pool id here
      region: region,
    ); // your region here

    print("outside loop");
    for (var i = 0; i < complaints.length; i++) {
      print("inside loop");

      String translated1 = await awsTranslate
          .translateText(complaints[i].title.toString(), to: 'kn');
      String translated2 = await awsTranslate
          .translateText(complaints[i].description.toString(), to: 'kn');
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
    super.initState();
    fetchData();
    GetPreferData();
    print("title lsit kannada ");
    print(title_kann);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(67,88,185,1.0),
        title: Text(
          language == "English" ? "History" : "ಇತಿಹಾಸ",
          style: TextStyle(
            color: primary_text_color,
          ),
        ),
        centerTitle: true,
      ),
      body: (complaints != null)
          ? (complaints.length > 0)
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: complaints.length,
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
                                                ComplaintDetailScreen(
                                                    complaint: complaints[i])));
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
                                                // language == "English"? complaints[i].title:title_kann[i],
                                                language == "English"
                                                    ? complaints[i].title
                                                    : (title_kann.length > i
                                                        ? title_kann[i]
                                                        : 'Please wait...'),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              language == "English"?"Complain Id : ":"ಐಡಿ ದೂರು : ",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                              width: width * 0.2,
                                              child: Text(
                                                complaints[i].sId == null
                                                    ? "123"
                                                    : complaints[i].sId,
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
                                          language == "English"
                                              ? complaints[i].description
                                              : (description_kann.length > i
                                                  ? description_kann[i]
                                                  : 'Please wait...'),
                                          //complaints[i].description,
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
              : Center(
        child: Text(
            language == "English" ? "No complaint History Found":"ಯಾವುದೇ ದೂರು ಇತಿಹಾಸ ಕಂಡುಬಂದಿಲ್ಲ",
            textAlign: TextAlign.center),
                )
          : Center(
              child: Text("No complaint History Found",
                  textAlign: TextAlign.center)),
    );
  }
}
