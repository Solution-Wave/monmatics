import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/urls.dart';


class AuthenticateController {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  Future login(String email , String password) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res=[];
  print(email);
  print(password);
  var body = {
    'email': email ,
    'password': password
  };
  var header= {
    'Accept': '*/*'
  };

    try{
      var response = await http.post(Uri.parse('$baseUrl/login'),body: body , headers: header);
      var data = jsonDecode(response.body);
      res.add(data['result']);
      res.add(data['message']);
      if(response.statusCode ==200)
      {
        prefs.setString('token', data['token']);
        prefs.setString('id', data['user']['id'].toString());
        prefs.setString('name', data['user']['name']);
        prefs.setString('email',  data['user']['email']);
        prefs.setString('role', data['user']['role']);
        return res;
      }
      else
      {
        res.add(data['result']);
        res.add(data['message']);
        return res;
      }
    }
    catch(SocketException){

      res.add('Something went wrong');
      return res;
    }


  }

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
