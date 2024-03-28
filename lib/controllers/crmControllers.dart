import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/urls.dart';


class TasksCont {

  Future getTasks(String token)async{
    var header= {
      'Authorization': 'Bearer $token',
    };

    try{
      var response = await http.get(Uri.parse(getTasksUrl) , headers: header);
      var data = jsonDecode(response.body);
      if(response.statusCode ==200)
      {

        return data['data'];
      }
      else
      {
        return 'Some error occured';
      }
    }
    catch(e){
      print(e);
      return e.toString();
    }

  }

}

class Notes{

  Future getNotes(String token)async{
    print(token);
    var header= {
      // 'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try{
      var response = await http.get(Uri.parse('https://dev.monmatics.com/monmatics/api/get_notes') , headers: header);
      var data=  jsonDecode(response.body);
      if(response.statusCode ==200)
      {
        return data['data'];
      }
      else
      {

        return 'Some error occured';
      }
    }
    catch(e){
      return e.toString();
    }

  }

  Future saveNotes()async{

  }

}

class LeadController {

  Future getLeadData(String token) async {
    var header = {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.get(Uri.parse(getLeads), headers: header);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data['data'];
      }
      else {
        return 'Some error occured';
      }
    }
    catch (e) {
      print(e);
    }
  }
}

class Customer{

  Future getCustomer(String token)async{
    var header= {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    try{
      var response = await http.get(Uri.parse('https://dev.monmatics.com/monmatics/api/get_customers') , headers: header);
      var data = jsonDecode(response.body);
      print(response.statusCode);
      print(response.body);
      if(response.statusCode ==200)
      {
        return data['data'];
      }
      else
      {

        return 'Some error occured';
      }
    }
    catch(e){
      print(e);
      return e.toString();
    }

  }

  Future saveNotes()async{

  }

}

class ContactController{

  Future getData(String token)async{
    var header= {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };
    try{
      var response = await http.get(Uri.parse(getContacts) , headers: header);
      var data = jsonDecode(response.body);
      if(response.statusCode ==200)
      {

        return data['data'];
      }
      else
      {

        return 'Some error occured';
      }
    }
    catch(e){
      print(e);
      return e.toString();
    }
  }



}

class CallsRecord {

  Future getRecord(String token)async{

    var header= {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    try{
      var response = await http.get(Uri.parse(getCallsUrl) , headers: header);
      var data = jsonDecode(response.body);
      if(response.statusCode ==200)
      {
        return data['data'];
      }
      else
      {

        return 'Some error occured';
      }
    }
    catch(e){
      print(e);
    }

  }

}


