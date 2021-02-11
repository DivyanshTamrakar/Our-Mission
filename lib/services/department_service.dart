import 'package:namma_badavane/models/department_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:namma_badavane/config.dart';
import 'package:namma_badavane/models/complaint_model.dart';
import 'package:namma_badavane/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class DepartmentApi{

  Future<List<Department>> getAllDepartments() async {
    List<Department> departments = [];
    try {
      var headers = {
        "Accept": "application/json",
        "Authorization":  token,
      };
      final response = await http.get('${BASE_URL}/department',
          headers: headers);
      print(response.body.toString());
      var responseData=json.decode(response.body)['data'];
      print("HTTP====================>$responseData");
      departments = ( responseData as List)
          .map((data) => Department.fromJson(data))
          .toList();
      return departments;
    }
    catch (e) {
      rethrow;
    }
  }



  Future<Department> getDepartment(String id) async {
    Department department;
    try {
      var headers = {
        "Accept": "application/json",
        "Authorization":  token,
      };
      final response = await http.get('${BASE_URL}/department/${id}',
          headers: headers);
      department = json.decode(response.body)['data'];
      return department;
    }
    catch (e) {
      rethrow;
    }
  }
}