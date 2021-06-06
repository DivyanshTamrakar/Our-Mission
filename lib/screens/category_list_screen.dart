import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/department_model.dart';
import '../screens/complaint_form_screen.dart';
import '../utils/colors.dart';
import 'homescreen.dart';

class CategoryListScreen extends StatefulWidget {
  final List<Department> departments;
  final int departmentNumber;

  CategoryListScreen({Key key, this.departments, this.departmentNumber})
      : super(key: key);

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  void initState() {
    print(widget.departments[widget.departmentNumber].subDepartment);
    print(widget.departments[widget.departmentNumber].subDepartmentKannada);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var subDepartment =
        widget.departments[widget.departmentNumber].subDepartment;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HomeScreen.color,
        title: Text("Choose Category",
            style: TextStyle(color: primary_text_color)),
      ),
      body: Container(
        height: height,
        width: width,
        child: ListView.builder(
            itemCount: subDepartment.length,
            itemBuilder: (context, i) {
              return Card(
                elevation: 5,
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ComplaintFormScreen(
                                  departments: widget.departments,
                                  subDepartment: subDepartment[i],
                                  departmentNumber: widget.departmentNumber,
                                )));
                  },
                  child: ListTile(
                    leading: Icon(Icons.info, color: HomeScreen.color),
                    title: Text(
                      subDepartment[i],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing:
                        Icon(Icons.arrow_forward, color: Colors.blueAccent),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
