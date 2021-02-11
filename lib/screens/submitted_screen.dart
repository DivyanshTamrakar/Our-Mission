import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      body: Column(
        children: [
          Container(
            height: 0.5*height,
            width: width,
            color: Colors.amber,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 30),
                Text("Your Complaint/Issue has been successfully registered.You will be notified if there will be any updates or progress",
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
                      width:width*0.8,
                      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.teal,
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
