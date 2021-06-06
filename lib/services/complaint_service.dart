import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../config.dart';
import '../models/complaint_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ComplaintApi {
  Future<void> registerComplaint(Complaint complaint, File file) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var dio = Dio();
      dio.options.headers["Authorization"] = prefs.getString('token');
      FormData formData = new FormData.fromMap({
        'title': complaint.title,
        'description': complaint.description,
        'contact': complaint.contact,
        'email': complaint.email,
        'location': complaint.location.coordinates.toString(),
        'department': complaint.department,
        'sub_department': complaint.subDepartment,
        "file": MultipartFile.fromFile(file.path),
      });
      var response = await dio.post(
        "$BASE_URL/complain/register",
        data: formData,
      );
      print(response.data.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Complaint>> getAllComplaints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Complaint> complaints;
    try {
      var headers = {
        "Accept": "application/json",
        // "Authorization": token,
        "Authorization": prefs.getString('token'),
      };

      final response =
          await http.get('$BASE_URL/complain/all', headers: headers);
      print(response.body.toString());
      complaints = (json.decode(response.body)['data'] as List)
          .map((data) => Complaint.fromJson(data))
          .toList();
      return complaints;
    } catch (e) {
      rethrow;
    }
  }

  Future<Complaint> getComplaint(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Complaint complaint;
    try {
      var headers = {
        "Accept": "application/json",
        // "Authorization": token,
        "Authorization": prefs.getString('token'),
      };
      final response =
          await http.get('$BASE_URL/complain/$id', headers: headers);
      complaint = json.decode(response.body)['data'];
      return complaint;
    } catch (e) {
      rethrow;
    }
  }
}
