import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namma_badavane/models/department_model.dart';
import 'package:namma_badavane/screens/complaint_form_screen.dart';
import 'package:namma_badavane/utils/colors.dart';

class CategoryListScreen extends StatefulWidget {
  final List<Department> departments;
  final int departmentNumber;

  CategoryListScreen({Key key, this.departments, this.departmentNumber})
      : super(key: key);

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  File image;

  _imgFromCamera() async {
    image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var subDepartment =
        widget.departments[widget.departmentNumber].subDepartment;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary_color,
        title: Text('Choose Category',
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
                    await _imgFromCamera();
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ComplaintFormScreen(
                                  departments: widget.departments,
                                  subDepartment: subDepartment[i],
                                  image: image,
                                  departmentNumber: widget.departmentNumber,
                                )));
                  },
                  child: ListTile(
                    leading: Icon(Icons.info, color: primary_color),
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
