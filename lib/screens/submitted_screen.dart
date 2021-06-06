import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/bottom_navigation.dart';

class SubmittedScreen extends StatefulWidget {
  @override
  _SubmittedScreenState createState() => _SubmittedScreenState();
}

class _SubmittedScreenState extends State<SubmittedScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromRGBO(246, 244, 246, 1.0),
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
              "Succefully Registered !",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(115, 114, 124, 1.0)),
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
                        "Your Complaint/Issue has been successfully registered.You will be notified if there will be any updates or progress",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(44, 53, 76, 1.0),
                        ),
                        textAlign: TextAlign.center,
                      )),
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
                            color: Color.fromRGBO(215, 111, 115, 1.0),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                'Back to Home',
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
