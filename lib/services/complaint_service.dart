import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:namma_badavane/config.dart';
import 'package:namma_badavane/models/complaint_model.dart';
import 'package:namma_badavane/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ComplaintApi {
  Future<void> registerComplaint(Complaint complaint, File file) async {
    try {
      var dio = Dio();
      dio.options.headers["Authorization"] = token;
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
        "${BASE_URL}/complain/register",
        data: formData,
      );
      print(response.data.toString());
      // Uint8List _file = await file.readAsBytes();
      // var request = http.MultipartRequest(
      //     'POST', Uri.parse(BASE_URL + "/complain/register")
      // );
      // request.headers['Authorization'] = "token";
      // 'title'] = complaint.title;
      // 'description'] = complaint.description;
      // 'contact'] = complaint.contact;
      // 'email'] = complaint.email;
      // 'location'] = complaint.location.coordinates.toString();
      // 'department'] = complaint.department;
      // 'sub_department'] = complaint.subDepartment;
      // request.files.add(http.MultipartFile.fromBytes('file', file.readAsBytesSync()),
      // );
      // var response = await request.send();
      // print(response.stream);
      // print(response.statusCode);
      // final res = await http.Response.fromStream(response);
      // print(res.body);
      // final response = await http.post(
      //   Uri.https(BASE_URL, "/complain/register"),
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: jsonEncode(<String, String>{
      //     "title": complaint.title,
      //     "description":complaint.description,
      //     "contact":complaint.contact ,
      //     "file": "",
      //     "email": complaint.email,
      //     "location":complaint.location.coordinates.toString(),
      //     "department":complaint.department,
      //     "sub_department":complaint.subDepartment,
      //   }),
      // );
      // Map<String, String> data = jsonDecode(response.body.toString());
      // if (data['status'] == "403")
      //   throw new Exception("Account not registered");
      // else {
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.setString("token", data['token']);
      // }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Complaint>> getAllComplaints() async {
    List<Complaint> complaints;
    try {
      var headers = {
        "Accept": "application/json",
        "Authorization": token,
      };
      final response =
          await http.get('${BASE_URL}/complain/all', headers: headers);
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
    Complaint complaint;
    try {
      var headers = {
        "Accept": "application/json",
        "Authorization": token,
      };
      final response =
          await http.get('${BASE_URL}/complain/${id}', headers: headers);
      complaint = json.decode(response.body)['data'];
      return complaint;
    } catch (e) {
      rethrow;
    }
  }
}
