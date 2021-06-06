import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config.dart';
import '../models/complaint_model.dart';
import '../models/department_model.dart';
import '../screens/category_list_screen.dart';
import '../screens/notification.dart';
import '../services/department_service.dart';
import '../utils/HttpResponse.dart';
import '../utils/colors.dart';


class HomeScreen extends StatefulWidget {
  static Color color = Color.fromRGBO(38, 40, 52, 1.0);
  static Color buttonBack = Color.fromRGBO(125, 140, 223, 1.0);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Complaint> complaints = [];
  var complaintLength;
  var solutionLength;
  var solvedLength;
  var pendingLength;
  List<Department> departments = [];

  fetchData() async {
    var data = await DepartmentApi().getAllDepartments();
    setState(() {
      departments = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    fetchDataforStatCard();
    getSolutionDataForStatCard();
    statusColor();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print(width);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color.fromRGBO(246, 244, 246, 1.0),
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
           "Departments",
          style: TextStyle(color: Color.fromRGBO(173, 171, 184, 1.0)),
        ),
        backgroundColor: Color.fromRGBO(22, 14, 27, 1.0),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_active_outlined,
                color: Color.fromRGBO(67, 88, 185, 1.0)),
            color: button_icon_color,
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => NotificationScreen()));
            },
          )
        ],
      ),
      body: (departments.length > 1)
          ? SingleChildScrollView(
        scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.all(3.0), //divyansh editing
                // padding: EdgeInsets.all(12.0),
                child: GridView.builder(

                  shrinkWrap: true,
                  itemCount: departments.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (width < 350) ? 2 : 3,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 15.0),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => CategoryListScreen(
                                    departments: departments,
                                    departmentNumber: index)));
                      },
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                  height: (width < 350)
                                      ? height * 0.13
                                      : height * 0.07,
                                  child: Image.network(departments[index].file)),
                              Divider(),
                              Text(
                                    departments[index].title,

                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: departments[index].title.length < 20
                                        ? 12
                                        : 9,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
                // Line with Text
                Row(children: <Widget>[
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                        )),
                  ),
                  Text('Complaint Status',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  Expanded(
                    child: new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                        )),
                  ),
                ]),
                // Status Card
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    padding: EdgeInsets.all(3.0),
                    children: <Widget>[
                      makeDashboardItem(
                           "Registered" ,
                          Icons.insert_comment,
                          Colors.yellow,
                          Colors.black,
                          complaintLength.toString()),
                      makeDashboardItem(
                           "Solved",
                          Icons.assignment_turned_in_rounded,
                          Colors.green,
                          Colors.white,
                          solutionLength.toString()),

                      makeDashboardItem(
                           "Pending",
                          Icons.pending_actions,
                          Colors.orangeAccent[400],
                          Colors.white,
                          pendingLength != null ? pendingLength.toString() : "0" ),
                    ],
                  ),
                ),
              ],
            ),
          )
          : Center(
        child: CircularProgressIndicator(),
      )
    ));
  }

  // stat card numbering

  fetchDataforStatCard() async {
    var resp = await HttpResponse.getResponse(service: '/complain');
    print("\n\n$resp\n\n");

    var response = jsonDecode(resp);
    print("\n\n${response.toString()}\n\n");

    setState(() {
      complaintLength = response['data'].length;
    });
  }

  getSolutionDataForStatCard() async {
    var resp = await HttpResponse.getResponse(service: '/solution');
    print("\n\n$resp\n\n");

    var response = jsonDecode(resp);
    print("\n\n${response.toString()}\n\n");

    setState(() {
      solutionLength = response['data'].length;
      if (solutionLength == null) {
        solutionLength = 0;
      }
      print(solutionLength);
      pendingLength = complaintLength - solutionLength;
      if (pendingLength == null) {
        pendingLength = 0;
      }
      print(pendingLength);

    });
  }


}


Card makeDashboardItem(String title, IconData icon, Color cardcolor,
    Color textcolor, String complaint) {
  return Card(
      elevation: 2.0,
      child: Container(
        decoration: BoxDecoration(color: cardcolor,borderRadius: BorderRadius.circular(4),),
        child: new InkWell(
          onTap: () {},
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 10.0),
                Center(
                    child: Icon(
                      icon,
                      size: 25.0,
                      color: Colors.white,
                    )),
                SizedBox(height: 5.0),
                new Center(
                  child: Container(
                    width: 110.0,
                    alignment: Alignment.center,
                    child: new Text(title,
                        textAlign: TextAlign.center,


                        style: new TextStyle(
                            fontSize: 15.0,
                            color: textcolor,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 2.0),
                new Center(
                  child: new Text(complaint,
                      style: new TextStyle(
                          fontSize: 25.0,
                          color: textcolor,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ),
      ));
}



