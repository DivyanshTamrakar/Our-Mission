import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namma_badavane/screens/homescreen.dart';
import 'package:namma_badavane/utils/bottom_navigation.dart';
class SubmittedScreen extends StatefulWidget {
  @override
  _SubmittedScreenState createState() => _SubmittedScreenState();
}

class _SubmittedScreenState extends State<SubmittedScreen> {
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          SizedBox(height: 30.0,),
          Image.asset("assets/registered.png"),
          SizedBox(height: 40.0,),
          Text("Succefully Registered !",style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 35.0),
                  child: Text("Your Complaint/Issue has been successfully registered.You will be notified if there will be any updates or progress",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Divider(
                    height: 5,
                  ),
                ),
                SizedBox(height: 30.0),

                Material(
                  elevation: 5,
                  borderRadius:BorderRadius.circular(20.0) ,
                  child: InkWell(
                    onTap: (){
                      Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(builder: (context) => BottomBarExample()),
                      (route) => false,);
                    },
                    child: Container(
                      width:width*0.75,
                      padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                      decoration: BoxDecoration(
                          color: HomeScreen.button_back,
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 15),
                          Expanded(
                            child: Text('Back to Home',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),),
                          ),
                          SizedBox(width: 10,),
                          Icon(Icons.check_circle_outline_sharp,
                            color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],

      ),
    );
  }
}
