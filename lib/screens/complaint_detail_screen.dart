import 'dart:convert';
import 'package:aws_translate/aws_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:namma_badavane/config.dart';
import 'package:namma_badavane/models/complaint_model.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:namma_badavane/widgets/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComplaintDetailScreen extends StatefulWidget {
  final Complaint complaint;
   // final id ;
  ComplaintDetailScreen({Key key, this.complaint}) : super(key: key);

  @override
  _ComplaintDetailScreenState createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends State<ComplaintDetailScreen> {
  TextEditingController _controller = new TextEditingController();
  var star_rating = 1;
  String language = "";
  String title = "";
  String status ="";
  String description = "";






  getaws() async{
    AwsTranslate awsTranslate = AwsTranslate(
        poolId: poolId, // your pool id here
        region: region,
    ); // your region here


    String translated1 = await awsTranslate.translateText(widget.complaint.title, to: 'kn');
    String translated2 = await awsTranslate.translateText(widget.complaint.description, to: 'kn');
    String translated3 = await awsTranslate.translateText(widget.complaint.status, to: 'kn');
    if (!mounted) return;
    setState(() {
      title = translated1.toString();
      description = translated2.toString();
      status = translated3.toString();
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


  @override
  void initState() {
    super.initState();
    print("Complaint data");
    GetPreferData();


  }


  GetPreferData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      language = pref.getString("language");
    });
    print(pref.getString("language"));
    print("language ========$language");
    print("language before aws function call ========$language");
    if(language != "English")
    {
      getaws();
    }
  }


  @override
  Widget build(BuildContext context) {
    var date = DateTime.parse(widget.complaint.dateOfComplain);
    var formattedDate = "${date.day}-${date.month}-${date.year}";
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(67,88,185,1.0),
        title: Text(
          language == "English"?
            "Complaint/Issue Detail":"ದೂರು / ಸಂಚಿಕೆ ವಿವರ",
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
                                width: width * 0.4,
                                child: Text(
                                  language == "English"? widget.complaint.title:title ==""?"Please wait...":title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: width * 0.20,
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
                              language == "English"?widget.complaint.description:description==""?"PLease wait...":description,
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
                                          Text("${language == "English" ? "Contact no -":"ಸಂಪರ್ಕಿಸಿ - "}"),
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
                                          Text("${language == "English"?"Email Id -":"ಇಮೇಲ್ ಐಡಿ -"}",overflow: TextOverflow.ellipsis,),
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
                                          Text("${language == "English"?"Status :-":"ಸ್ಥಿತಿ :-"}"),
                                          SizedBox(width: 5),
                                          // Text("Submitted"),
                                          Text(
                                            language == "English"?
                                              widget.complaint.status:status==""?"Please wait...":status, overflow: TextOverflow.ellipsis,
                                          ),
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
                      language == "English"?"Provide Feedback to Us !":"ನಮಗೆ ಪ್ರತಿಕ್ರಿಯೆ ನೀಡಿ!",
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
                            language == "English" ? 'Feel free to provide your feedback over here (optional) !':'ನಿಮ್ಮ ಪ್ರತಿಕ್ರಿಯೆಯನ್ನು ಇಲ್ಲಿ ನೀಡಲು ಹಿಂಜರಿಯಬೇಡಿ  (ಐಚ್ al ಿಕ)!',
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
                  Container(
                    child: RatingBar.builder(
                      initialRating: 2,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          star_rating = rating.toInt();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20.0),
                    child: GestureDetector(
                      onTap: () async {

                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        var headers = {
                          "Authorization":  prefs.getString("token"),
                          // "Authorization": token,
                          "Content-Type": "application/json",

                        };
                        print(headers);
                        print(_controller.text.toString());
                        var map = new Map<String, dynamic>();
                        map["description"] = _controller.text.toString();
                        map['rating'] = star_rating;
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






                        // if (_controller.text.toString() == "") {
                        //   showDialog(
                        //       context: context,
                        //       builder: (BuildContext context) {
                        //         return oneButtonDialog(
                        //             context: context,
                        //             title: "Feedback Can't be Empty",
                        //             content: "Feedback must be filled",
                        //             actionTitle: "OK");
                        //       });
                        // }
                        // else {
                        //   SharedPreferences prefs =
                        //       await SharedPreferences.getInstance();
                        //   var headers = {
                        //     "Authorization":  prefs.getString("token"),
                        //     // "Authorization": token,
                        //     "Content-Type": "application/json",
                        //
                        //   };
                        //   print(headers);
                        //   print(_controller.text.toString());
                        //   var map = new Map<String, dynamic>();
                        //   map["description"] = _controller.text.toString();
                        //   map['rating'] = star_rating;
                        //   print("Params Feedback Data " + map.toString());
                        //   print("map + $map");
                        //   final msg  = jsonEncode(map);
                        //   print(msg);
                        //   final resp = http
                        //       .post("${BASE_URL}/feedback/new-feedback",
                        //           body: msg, headers: headers)
                        //       .then((http.Response response) {
                        //     if (response.statusCode < 200 ||
                        //         response.statusCode > 400 ||
                        //         json == null) {
                        //       print(
                        //           'HttpResponse==' + response.body.toString());
                        //       throw new Exception(
                        //           "Error while fetching============================");
                        //     }
                        //     print(response.body.toString());
                        //
                        //     Map<String, dynamic> data =
                        //         jsonDecode(response.body);
                        //
                        //     print("Divyansh + $data"); // divyansh
                        //
                        //     if (data['status'] == "201") {
                        //       showDialog(
                        //           context: context,
                        //           builder: (BuildContext context) {
                        //             return oneButtonDialog(
                        //               context: context,
                        //               title: "Successfull",
                        //               content: "Your record has been recorded!",
                        //               actionTitle: "OK",
                        //             );
                        //           });
                        //     }
                        //   });
                        //   Navigator.pop(context);
                        // }
                      },
                      child: Container(
                        width: width * 0.8,
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(215,111,115,1.0),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                language=="English"?'Submit Feedback':'ಪ್ರತಿಕ್ರಿಯೆಯನ್ನು ಸಲ್ಲಿಸಿ',
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
