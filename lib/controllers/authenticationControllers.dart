import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/urls.dart';


class AuthenticateController {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  Future<Map<String, dynamic>> login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      http.Response response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      // Parse the response JSON
      Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // If login is successful, save user data and token in SharedPreferences
        Map<String, dynamic> userData = data['user'];
        userData.forEach((key, value) {
          prefs.setString(key, value.toString());
        });
        String? token = data['user']['api_token'];
        int id = data['user']['id'];
        if (token != null) {
          prefs.setString('token', token);
          prefs.setString('id', id.toString());
        } else {
          throw Exception('Token not found in response data');
        }

        // Save database_info in SharedPreferences
        Map<String, dynamic> databaseInfo = data['database_info'] ?? {};
        // Convert databaseInfo to a JSON string before saving
        String databaseInfoJson = jsonEncode(databaseInfo);
        prefs.setString('database_info', databaseInfoJson);

        return {
          'status': 200,
          'result': true,
          'message': 'Login Successful',
          'user': userData,
          'database_info': databaseInfo,
        };
      } else {
        return {
          'status': response.statusCode,
          'result': false,
          'message': data['message'] ?? 'Login Failed',
        };
      }
    } on SocketException {
      return {
        'status': -1,
        'result': false,
        'message': 'Network error occurred',
      };
    } catch (e) {
      return {
        'status': -1,
        'result': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }





  // Register Function
  Future register(String email, String name, String password ) async{
   var res=[];
    var body = {
      'email': email ,
      'name': name ,
      'password': password
    };
    var header= {
      'Accept': '*/*'
    };

    try{
      var response = await http.post(Uri.parse(registerUrl),body: body , headers: header);
      var data = jsonDecode(response.body);
      res.add(data['result']);
      res.add(data['message']);
      return res;
    }
    catch(e){
      res.add('Something went wrong');
      return res;
    }
  }



}
