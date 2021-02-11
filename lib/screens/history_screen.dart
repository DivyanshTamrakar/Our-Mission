import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namma_badavane/models/complaint_model.dart';
import 'package:namma_badavane/screens/complaint_detail_screen.dart';
import 'package:namma_badavane/services/complaint_service.dart';
import 'package:namma_badavane/utils/colors.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Complaint> complaints=[];
  fetchData()async{
    var data=await ComplaintApi().getAllComplaints();
    setState(() {
      complaints=data;
      print("complaints = $complaints");
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary_color,
        title: Text("History",
        style: TextStyle(
          color:primary_text_color,
        ),
        ),
        centerTitle: true,
      ),
      body: (complaints!=null)?(complaints.length>0)?Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       SizedBox(width: 10,),
          //       Text("List of available Compaints"),
          //       SizedBox(width: 10,),
          //       Expanded(
          //           child: Divider(
          //             color: Colors.grey[500],
          //           )
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
                itemCount: complaints.length,
                itemBuilder: (context, i) {
                  return Container(
                    margin: EdgeInsets.all(5),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          side: new BorderSide(color: Colors.grey[300], width: 1.0),
                          borderRadius: BorderRadius.circular(4.0)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4.0),
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ComplaintDetailScreen(complaint:complaints[i])));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 15, bottom: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: width*0.5,
                                    child: Text(
                                      complaints[i].title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "Complain Id:",
                                    style: TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: width*0.2,
                                    child: Text(
                                      complaints[i].sId==null?"123":complaints[i].sId,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Divider(
                                  height: 1,
                                  color: Colors.grey[500],
                                ),
                              ),
                              Text(
                                complaints[i].description,
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
      ):Center(child: Text("No complaint History Found",
      textAlign: TextAlign.center)):
      Center(child: CircularProgressIndicator(),),
    );
  }
}
