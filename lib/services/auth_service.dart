import 'dart:convert';
import 'package:namma_badavane/config.dart';
import 'package:namma_badavane/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth{
  Future<void> signUp(String number) async {
    try {
      final response = await http.post(
        Uri.https(BASE_URL, "/users/signup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'contact': number,
        }),
      );
      Map<String, String> data = jsonDecode(response.body.toString());
      if (data['status'] == "403")
        throw new Exception("User already registered");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyOTP(String pin) async {
    try {
      final response = await http.post(
        Uri.https(BASE_URL, "/users/otp-verification"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'otp': pin,
        }),
      );
      Map<String, String> data = jsonDecode(response.body.toString());
      if (data['status'] == "403")
        throw new Exception("User wrong otp");
      else
        {
          SharedPreferences prefs= await SharedPreferences.getInstance();
          prefs.setString("token", data['token']);
          prefs.setString("id", data['id']);
        }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeProfile(User user) async {
    try {
      final response = await http.post(
        Uri.https(BASE_URL, "/users/profile-completion"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': user.name,
          "email":user.email,
          'profile':user.profile,
          'address':user.address,
          'location':user.location.coordinates.toString()
        }),
      );
        Map<String, String> data = jsonDecode(response.body.toString());
        SharedPreferences prefs= await SharedPreferences.getInstance();
        prefs.setString("user", user.toJson().toString());
    } catch (e) {
      rethrow;
    }
  }



  Future<void> updateProfile(User user) async {
    try {
      final response = await http.post(
        Uri.parse("$BASE_URL/users/profile-update"),
        headers: {
          "Authorization":token
        },
        body: jsonEncode(<String,dynamic>{
          "name": user.name,
          "email":user.email,
          "contact":user.contact,
          "profile":user.profile,
          "address":user.address,
          "location":user.location.coordinates.toString()
        }),
      );
      print(response.body.toString());
      var  data = jsonDecode(response.body.toString());
      SharedPreferences prefs= await SharedPreferences.getInstance();
      prefs.setString("user", user.toJson().toString());
    } catch (e) {
      rethrow;
    }
  }


  Future<User> getProfile() async {
    try {
      var headers = {
        "Accept": "application/json",
        "Authorization": token,
      };
      final response = await http.get('${BASE_URL}/users/profile',
          headers: headers);
       print(response.body.toString());
       return User.fromJson(json.decode(response.body)['data']);
    }
    catch (e) {
      rethrow;
    }
  }




  Future<void> sendOTP(String number) async {
    try {
      final response = await http.post(
        Uri.https(BASE_URL, "/users/send-otp"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'contact': number,
        }),
      );
      Map<String, String> data = jsonDecode(response.body.toString());
      if (data['status'] == "403")
        throw new Exception("Account not registered");
    } catch (e) {
      rethrow;
    }
  }
  Future<void> signIn(String number,String otp) async {
    try {
      final response = await http.post(
        Uri.https(BASE_URL, "/users/signin"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'contact': number,
          'otp': otp
        }),
      );
      Map<String, String> data = jsonDecode(response.body.toString());
      if (data['status'] == "403")
        throw new Exception("Account not registered");
      else{
        SharedPreferences prefs= await SharedPreferences.getInstance();
        prefs.setString("token", data['token']);
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<void> logout()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.clear();
  }

}
