import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:namma_badavane/utils/HttpResponse.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:namma_badavane/widgets/dialogs.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:namma_badavane/screens/edit_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OTPScreen extends StatefulWidget {
  final String contact;
  OTPScreen({Key key,this.contact}):super(key: key);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  String _otpPin="";
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 0.3*height,
                width: width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/otp_green.png"),
                      ))
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text("An OTP has been sent to your registered mobile number",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Divider(
                        height: 1,
                      ),
                    ),
                    OTPTextField(
                      length: 6,
                      width: width,
                      fieldWidth: width*0.13,
                      style: TextStyle(
                          fontSize: 17
                      ),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.box,
                      onCompleted: (pin) {
                        _otpPin=pin;
                      },
                    ),
                    SizedBox(
                      height:20
                    ),
                    Material(
                      elevation: 5,
                      borderRadius:BorderRadius.circular(20.0) ,
                      child: InkWell(
                        onTap: () async {
                          // Navigator.push(
                          //     context, CupertinoPageRoute(
                          //     builder: (context) => EditProfileScreen(
                          //       newUser: false,
                          //     )));



                          if(_otpPin.length==6) {

                            try{
                              Map data={
                                "otp":_otpPin
                              };
                              var resp = await HttpResponse.postResponse(
                                  service: '/users/otp-verification', data: data);
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
                                          title: "Invalid OTP",
                                          content: response['error'],
                                          actionTitle: "OK"
                                      );
                                    });
                                //print('Invalid Number');
                              }
                              else {
                                SharedPreferences prefs = await SharedPreferences
                                    .getInstance();
                                prefs.setString('token', response['token']);
                                prefs.setString('id', response['id']);
                                Navigator.push(
                                    context, CupertinoPageRoute(
                                    builder: (context) => EditProfileScreen(
                                      newUser: true,
                                    )));
                              }
                            }
                            catch(e){

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return oneButtonDialog(
                                        context: context,
                                        title: "Network Error",
                                        content: e.toString(),
                                        actionTitle: "OK");
                                  });

                            }
                            }
                        else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return oneButtonDialog(
                                      context: context,
                                      title: "Invalid Pin",
                                      content: "Please enter complete 6 digit pin",
                                      actionTitle: "OK"
                                  );
                                });
                            //print('Invalid Number');

                          }
                          },
                        child: Container(
                          width:width*0.8,
                          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                          decoration: BoxDecoration(
                              color: button_color,
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 15),
                              Expanded(
                                child: Text('Submit OTP',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: button_text_color,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),),
                              ),
                              SizedBox(width: 10,),
                              Icon(Icons.check_circle_outline_sharp,
                                color: button_icon_color,)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              child: Divider()
                          ),
                          SizedBox(width: 20),
                          Text("OR"),
                          SizedBox(width: 20),
                          Expanded(
                              child: Divider()
                          ),
                        ],
                      ),
                    ),
                    Material(
                      elevation: 5,
                      borderRadius:BorderRadius.circular(20.0) ,
                      child: Container(
                        width:width*0.8,
                        padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 15),
                            Expanded(
                              child: Text('Resend OTP',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: button_text_color,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),),
                            ),
                            SizedBox(width: 10,),
                            Icon(Icons.mobile_screen_share,
                              color: button_icon_color,)
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
              )
            ],

          ),
        ),
      ),
    );
  }
}
