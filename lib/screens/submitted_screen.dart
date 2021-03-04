import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namma_badavane/screens/homescreen.dart';
import 'package:namma_badavane/utils/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubmittedScreen extends StatefulWidget {
  @override
  _SubmittedScreenState createState() => _SubmittedScreenState();
}

class _SubmittedScreenState extends State<SubmittedScreen> {
  String language = "";

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
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromRGBO(246,244,246,1.0),
      body: Column(
        children: [
          SizedBox(
            height: 30.0,
          ),
          Image.asset("assets/registered.png"),
          SizedBox(
            height: 40.0,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              language == "English"?
                   "Succefully Registered !"
                  : "ಯಶಸ್ವಿಯಾಗಿ ನೋಂದಾಯಿಸಲಾಗಿದೆ!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Color.fromRGBO(115,114,124,1.0)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),

            child: Container(

              child: Column(

                children: [
                  SizedBox(height: 30),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 35.0),
                      child: Text(
                        language == "English"
                            ? "Your Complaint/Issue has been successfully registered.You will be notified if there will be any updates or progress"
                            : "ನಿಮ್ಮ ದೂರು / ಸಂಚಿಕೆ ಯಶಸ್ವಿಯಾಗಿ ನೋಂದಾಯಿಸಲಾಗಿದೆ.ಯಾವುದೇ ನವೀಕರಣಗಳು ಅಥವಾ ಪ್ರಗತಿಯಿದ್ದರೆ ನಿಮಗೆ ಸೂಚಿಸಲಾಗುತ್ತದೆ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(44,53,76,1.0),
                        ),
                        textAlign: TextAlign.center,
                      )),
                  // Padding(
                  //   padding: const EdgeInsets.all(20.0),
                  //   child: Divider(
                  //     height: 5,
                  //   ),
                  // ),
                  SizedBox(height: 30.0),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => BottomBarExample()),
                          (route) => false,
                        );
                      },
                      child: Container(
                        width: width * 0.75,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(215,111,115,1.0),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                language == "English"
                                    ? 'Back to Home'
                                    : 'ಮರಳಿ ಮನೆಗೆ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.check_circle_outline_sharp,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
