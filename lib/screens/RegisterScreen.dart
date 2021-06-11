import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/LoginScreen.dart';
import '../utils/HttpResponse.dart';
import '../utils/colors.dart';
import '../widgets/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Register_otp_screen.dart';

class ScreenSignup extends StatefulWidget {
  _ScreenSignupState createState() => _ScreenSignupState();
}

class _ScreenSignupState extends State<ScreenSignup> {
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: InkWell(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset('assets/bidar.jpg',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center),
              ClipRRect(
                // Clip it cleanly.
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.grey.withOpacity(0.1),
                    alignment: Alignment.center,
                  ),
                ),
              ),

// black bacgorund and text

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height / 4.5),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 2.2,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[],
                      )),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          // CircularProgressIndicator(),
                          Container(
                            height: 50,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Spacer(),
                                Text(
                                    "Don't worry we're here to solve your Issues",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: button_text_color)),
                                Spacer(),
                              ]),
                          // CircularProgressIndicator(),
                          Container(
                            height: 20,
                          ),
                          // Column(
                          //   children: [
                          //     Text("Powered by",
                          //         style: TextStyle(
                          //             fontSize: 20,
                          //             fontWeight: FontWeight.bold,
                          //             color: button_text_color)),
                          //     Image.asset(
                          //       "assets/footer.png",
                          //       fit: BoxFit.cover,
                          //       height: 50,
                          //       width: 190.0,
                          //       color: Colors.white,
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

// signup and footer

              Column(
                children: [
                  SizedBox(height: 40),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Our",
                              style: TextStyle(
                                  fontSize: 40, color: Colors.orange,fontWeight: FontWeight.bold)),
                          SizedBox(width: MediaQuery.of(context).size.width/30,),
                          Text("Mission",
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))
                        ]),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 15,
                  ),

                  // SizedBox(height: MediaQuery.of(context).size.height/5.4,),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        "assets/profile_placeholder.png",
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: width,
                    child: Text(
                      "To continue,enter your phone Number",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    height: 1,
                    endIndent: 50,
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(30),
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: new InputDecoration(
                            counterText: "",
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.zero,
                            hintStyle: new TextStyle(color: Colors.grey[800]),
                            hintText: "Enter Phone Number",
                            prefixIcon: Icon(Icons.call,
                                color: Color.fromRGBO(223, 143, 96, 1.0)),
                            fillColor: primary_text_color),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    height: 1,
                    indent: width * 0.1,
                    endIndent: width * 0.1,
                  ),
                  SizedBox(height: 10),
                  Material(
                    color: Colors.transparent,
                    // elevation: 5,
                    borderRadius: BorderRadius.circular(20.0),
                    child: InkWell(
                      onTap: () async {
                        // Navigator.push(
                        //               context,
                        //               CupertinoPageRoute(
                        //                   builder: (context) => OTPScreen(
                        //                       contact: _controller.text)));

                        if (_controller.text.length == 10)
                          try {
                            Map data = {"contact": _controller.text.toString()};
                            var resp = await HttpResponse.postResponse(
                                service: '/users/signup', data: data);
                            print("\n\n$resp\n\n");
                            print(data);
                            var response = jsonDecode(resp);
                            print("\n\n${response.toString()}\n\n");
                            if (response['status'] == '403') {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return oneButtonDialog(
                                        context: context,
                                        title: "Already registered",
                                        content: response['error'],
                                        actionTitle: "OK");
                                  });
                              //print('Invalid Number');
                            } else {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('contact', _controller.text);
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => OTPScreen(
                                          contact: _controller.text)));
                            }
                          } catch (e) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return oneButtonDialog(
                                      context: context,
                                      title: "Network Error",
                                      content: "Check Your Internet Connection",
                                      actionTitle: "OK");
                                });
                            // print('Invalid Number');
                          }
                        else
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return oneButtonDialog(
                                    context: context,
                                    title: "Invalid Number",
                                    content:
                                        "Please enter a valid 10 digit mobile number",
                                    actionTitle: "OK");
                              });
                        print('Invalid Number');
                      },
                      child: Container(
                        // width: width * 0.8,
                        margin: EdgeInsets.symmetric(horizontal: 80.0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(67, 88, 185, 1.0),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                'Sign Up',
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
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) => Screen()));
                      // Navigator.push(
                      //     context,
                      //     CupertinoPageRoute(
                      //         builder: (context) => BottomBarExample()));
                    },
                    child: Text(
                      "Already Registered ? Sign in ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
