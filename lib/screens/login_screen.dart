import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:namma_badavane/screens/otp_screen.dart';
import 'package:namma_badavane/utils/HttpResponse.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:namma_badavane/widgets/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'otp_screen_after_login.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: height * 0.52,
                    width: width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/signup_blue.png"),
                        ))),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        child: Text(
                          "To continue,enter your phone Number",
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        height: 1,
                        endIndent: 50,
                      ),
                      SizedBox(height: 20),
                      Material(
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
                                  color: primary_color),
                              fillColor: primary_text_color),
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
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20.0),
                        child: InkWell(
                          onTap: () async {
                            if (_controller.text.length == 10)
                              try {
                                Map data={
                                  "contact":_controller.text.toString()
                                };
                                var resp = await HttpResponse.postResponse(
                                    service: '/users/send-otp', data: data);
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
                                            actionTitle: "OK"
                                        );
                                      });
                                  //print('Invalid Number');
                                }
                                else {
                                  SharedPreferences prefs = await SharedPreferences
                                      .getInstance();
                                  prefs.setString('contact', _controller.text);
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => OTPScreenAfterLogin(
                                              contact: _controller.text)));
                                }
                              } catch (e) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return oneButtonDialog(
                                          context: context,
                                          title: "Network Error",
                                          content: "Please check your internet connection",
                                          actionTitle: "OK"
                                      );
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
                                        content: "Please enter a valid 10 digit mobile number",
                                        actionTitle: "OK"
                                    );
                                  });
                            print('Invalid Number');
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
                                    'Sign In',
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
                      Text(
                        "Terms & Conditions Applied*",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
