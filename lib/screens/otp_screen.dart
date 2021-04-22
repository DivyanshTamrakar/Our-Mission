import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:namma_badavane/utils/HttpResponse.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:namma_badavane/widgets/dialogs.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:namma_badavane/screens/edit_profile_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_button/timer_button.dart';


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
        backgroundColor: Color.fromRGBO(234,232,232,1.0),
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
                      color: Color.fromRGBO(115,114,124,1.0),
                    ),
                    textAlign: TextAlign.center,),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Divider(
                        height: 1,
                      ),
                    ),

                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      keyboardType: TextInputType.number,
                      backgroundColor: Colors.transparent,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        activeColor: Colors.grey,
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        inactiveColor: Colors.grey,

                      ),
                      onChanged: (value) {
                        print(value);
                      },
                      onCompleted: (v) {
                        setState(() {
                          _otpPin = v;
                          print(v);
                        });
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
                                        content: "Something went wrong",
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
                              color: Color.fromRGBO(215, 111, 115, 1.0),
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
                    Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Divider(
                              color: Colors.black,
                              height: 46,
                            )),
                      ),
                      Text('OR',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                      Expanded(
                        child: new Container(
                            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                    ]),
                    Material(
                      child: Container(
                        width:width*0.8,
                        padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(234,232,232,1.0),
                            borderRadius: BorderRadius.circular(0.0)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 15),
                            Expanded(
                              child: new TimerButton(
                                label: "Resend OTP",
                                timeOutInSeconds: 60,
                                onPressed: () async {

                                  if (_otpPin.length == 0)
                                    try {
                                      Map data={
                                        "contact":widget.contact,
                                      };
                                      var resp = await HttpResponse.postResponse(
                                          service: '/users/send-otp', data: data);
                                      print("\n\n$resp\n\n");
                                      print(data);
                                      var response = jsonDecode(resp);
                                      print("\n\n${response.toString()}\n\n");
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return oneButtonDialog(
                                                context: context,
                                                title: "Successfull!",
                                                content: " An OTP has been sent to your registered mobile number !",
                                                actionTitle: "OK"
                                            );
                                          });
                                    }
                                    catch (e) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return oneButtonDialog(
                                                context: context,
                                                title: "Network Error",
                                                content: "Something went wrong",
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

                                },
                                disabledColor: Colors.grey,
                                color: Color.fromRGBO(107,64,70,1.0),
                                disabledTextStyle: new TextStyle(color:Colors.grey,fontSize: 15.0),
                                activeTextStyle: new TextStyle(fontSize: 15.0, color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 10,),

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
