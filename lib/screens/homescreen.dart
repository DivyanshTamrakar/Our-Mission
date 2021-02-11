import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namma_badavane/config.dart';
import 'package:namma_badavane/models/department_model.dart';
import 'package:namma_badavane/screens/category_list_screen.dart';
import 'package:namma_badavane/screens/notification.dart';
import 'package:namma_badavane/services/department_service.dart';
import 'package:namma_badavane/utils/colors.dart';
import 'package:translator/translator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Department> departments = [];
  List<dynamic> KannadaTranslation;

  fetchData() async {
    final translator = GoogleTranslator();
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
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print(width);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Departments",
          style: TextStyle(color: primary_text_color),
        ),
        backgroundColor: primary_color,
        actions: [
          IconButton(
            icon:
                Icon(Icons.notifications_active_outlined, color: Colors.white),
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
          ? Container(
        margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.all(6.0), //divyansh editing
              // padding: EdgeInsets.all(12.0),
              child: GridView.builder(
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
              ))
          : Center(
              child: CircularProgressIndicator(),
            ),
    ));
  }
}
