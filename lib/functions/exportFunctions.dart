import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../models/contactItem.dart';
import '../../models/customerItem.dart';
import '../../models/leadItem.dart';
import '../../models/noteItem.dart';
import '../../models/taskItem.dart';
import '../../utils/urls.dart';
import 'importFunctions.dart';
import 'searchFunctions.dart';

class Ids {
  final String assignId;
  final String relatedId;

  Ids(this.assignId, this.relatedId);
}

class ExportFunctions {

  late final SearchFunctions searchFunctions;
  ImportFunctions importFunctions = ImportFunctions();

  // Add lead To API
  Future<void> postLeadToApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? id = prefs.getString('id');

    if (token == null) {
      print('Token not found in SharedPreferences');
      return;
    }

    String apiUrl = saveLeads;
    print(apiUrl);
    print(id);

    try {
      Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
      if (databaseInfo == null) {
        print('Database info not found');
        return;
      }
      String companyId = databaseInfo['company_id'] ?? '';
      print(companyId);

      // Open Hive box
      Box? leadBox = await Hive.openBox<LeadHive>("leads");

      List<dynamic> leadsDynamic = leadBox.values.toList();
      List<LeadHive> leads = leadsDynamic.cast<LeadHive>();

      for (LeadHive lead in leads) {
        // Check if lead already exists before attempting to add
        bool leadExists = await checkLeadExists(lead, databaseInfo);
        if (leadExists) {
          print('Lead already exists: ${lead.name}');
          continue;
        }
        // Prepare data to add lead
        Map<String, dynamic> postData = {
          'id': lead.id,
          'type': lead.type,
          'name': lead.name,
          'mobile': lead.phone,
          'email': lead.email,
          'companyId': companyId,
          'userId': id,
          'status': lead.status,
          'category' : lead.category,
          'note' : lead.note,
          'created_by' : id,
          'lead_source' : lead.leadSource,
          'created_at': DateTime.now().toIso8601String(),
        };

        String jsonData = jsonEncode(postData);
        String databaseInfoQuery = '';
        databaseInfo.forEach((key, value) {
          databaseInfoQuery += '&$key=$value';
        });

        String finalUrl = '$apiUrl?_token=$token$databaseInfoQuery';
        http.Response response = await http.post(
          Uri.parse(finalUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonData,
        );

        if (response.statusCode == 200) {
          print('lead added successfully: ${lead.name}');
        } else {
          print('Failed to add lead ${lead.name}. Error: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  Future<bool> checkLeadExists(LeadHive lead, Map<String, dynamic>? databaseInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found in SharedPreferences');
    }

    String apiUrl = getLeads;
    String email = lead.email ?? '';
    String phone = lead.phone ?? '';

    try {
      if (databaseInfo == null) {
        throw Exception('Database info not available');
      }

      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });

      String finalUrl = '$apiUrl?_token=$token$databaseInfoQuery';
      http.Response response = await http.get(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> data = responseData['data'];
        for (var dbLead in data) {
          String dbEmail = dbLead['email'] ?? '';
          String dbPhone = dbLead['mobile'] ?? '';
          if (dbEmail == email || dbPhone == phone) {
            print('lead already exists');
            return true;
          }
        }

        print('lead does not exist');
        return false;
      } else {
        throw Exception('Failed to check lead existence. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error checking lead existence: $error');
      throw error;
    }
  }

  // Add customer To API
  Future<void> postCustomerToApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? id = prefs.getString('id');

    if (token == null) {
      print('Token not found in SharedPreferences');
      return;
    }

    String apiUrl = saveCustomers;
    print(apiUrl);
    print(id);

    try {
      Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
      if (databaseInfo == null) {
        print('Database info not found');
        return;
      }
      String companyId = databaseInfo['company_id'] ?? '';
      print(companyId);

      // Open Hive box
      Box? customerBox = await Hive.openBox<CustomerHive>("customers");

      List<dynamic> customersDynamic = customerBox.values.toList();
      List<CustomerHive> customers = customersDynamic.cast<CustomerHive>();
      for (CustomerHive customer in customers) {
        // Check if customer already exists before attempting to add
        bool customerExists = await checkCustomerExists(customer, databaseInfo);
        if (customerExists) {
          print('Customer already exists: ${customer.name}');
          continue;
        }

        // Prepare data to add customer
        Map<String, dynamic> postData = {
          'type': customer.type,
          'name': customer.name,
          'mobile': customer.phone,
          'email': customer.email,
          'companyId': companyId,
          'userId': id,
          'created_at': DateTime.now().toIso8601String(),
        };

        String jsonData = jsonEncode(postData);
        String databaseInfoQuery = '';
        databaseInfo.forEach((key, value) {
          databaseInfoQuery += '&$key=$value';
        });

        String finalUrl = '$apiUrl?$databaseInfoQuery';
        http.Response response = await http.post(
          Uri.parse(finalUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonData,
        );

        if (response.statusCode == 200) {
          print('customer added successfully: ${customer.name}');
        } else {
          print('Failed to add customer ${customer.name}. Error: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  Future<bool> checkCustomerExists(CustomerHive customer, Map<String, dynamic>? databaseInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found in SharedPreferences');
    }

    String apiUrl = getCustomer;
    String email = customer.email ?? '';
    String phone = customer.phone ?? '';

    try {
      if (databaseInfo == null) {
        throw Exception('Database info not available');
      }

      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });

      String finalUrl = '$apiUrl?_token=$token$databaseInfoQuery';
      http.Response response = await http.get(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> data = responseData['data'];
        for (var dbCustomer in data) {
          String dbEmail = dbCustomer['email'] ?? '';
          String dbPhone = dbCustomer['mobile'] ?? '';
          if (dbEmail == email || dbPhone == phone) {
            print('customer already exists');
            return true;
          }
        }

        print('customer does not exist');
        return false;
      } else {
        throw Exception('Failed to check customer existence. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error checking customer existence: $error');
      throw error;
    }
  }

  // Add Contact To API
  Future<void> postContactsToApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? id = prefs.getString('id');

    if (token == null) {
      print('Token not found in SharedPreferences');
      return;
    }

    String apiUrl = saveContacts;
    print(apiUrl);
    print(id);

    try {
      Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
      if (databaseInfo == null) {
        print('Database info not found');
        return;
      }
      String companyId = databaseInfo['company_id'] ?? '';
      print(companyId);

      // Open Hive box
      Box? contactBox = await Hive.openBox<ContactHive>("contacts");

      List<dynamic> contactsDynamic = contactBox.values.toList();
      List<ContactHive> contacts = contactsDynamic.cast<ContactHive>();
      for (ContactHive contact in contacts) {
        // Check if contact already exists before attempting to add
        bool contactExists = await checkContactExists(contact, databaseInfo);
        if (contactExists) {
          print('Contact already exists: ${contact.fName} ${contact.lName}');
          continue;
        }

        // Prepare data to add contact
        Map<String, dynamic> postData = {
          'type': contact.type,
          'fname': contact.fName,
          'lname': contact.lName,
          'title': contact.title,
          'related_to_type': contact.relatedTo,
          'related_ID': contact.search,
          'assign_ID': contact.assignTo,
          'mobile': contact.phone,
          'email': contact.email,
          'office_phone': contact.officePhone,
          'companyId': companyId,
          'userId': id,
          'created_at': DateTime.now().toIso8601String(),
        };

        String jsonData = jsonEncode(postData);
        String databaseInfoQuery = '';
        databaseInfo.forEach((key, value) {
          databaseInfoQuery += '&$key=$value';
        });

        String finalUrl = '$apiUrl?_token=$token$databaseInfoQuery';
        http.Response response = await http.post(
          Uri.parse(finalUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonData,
        );

        if (response.statusCode == 200) {
          print('Contact added successfully: ${contact.fName} ${contact.lName}');
        } else {
          print('Failed to add contact ${contact.fName} ${contact.lName}. Error: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  Future<bool> checkContactExists(ContactHive contact, Map<String, dynamic>? databaseInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found in SharedPreferences');
    }

    String apiUrl = getContacts;
    String email = contact.email ?? '';
    String phone = contact.phone ?? '';

    try {
      if (databaseInfo == null) {
        throw Exception('Database info not available');
      }

      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });

      String finalUrl = '$apiUrl?_token=$token$databaseInfoQuery';
      http.Response response = await http.get(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> data = responseData['data'];
        for (var dbContact in data) {
          String dbEmail = dbContact['email'] ?? '';
          String dbPhone = dbContact['mobile'] ?? '';
          if (dbEmail == email || dbPhone == phone) {
            print('Contact already exists');
            return true;
          }
        }

        print('Contact does not exist');
        return false;
      } else {
        throw Exception('Failed to check contact existence. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error checking contact existence: $error');
      throw error;
    }
  }

  // Add Notes To API
  Future<void> postNotesToApi(Box<NoteHive> notesBox, Ids ids) async {
    String assignId = ids.assignId;
    String relatedId = ids.relatedId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? id = prefs.getString('id');

    if (token == null) {
      print('Token not found in SharedPreferences');
      return;
    }

    String apiUrl = saveUpdate;
    print(apiUrl);
    print(id);

    try {
      Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
      if (databaseInfo == null) {
        print('Database info not found');
        return;
      }
      String companyId = databaseInfo['company_id'] ?? '';
      print(companyId);
      List<dynamic> contactsDynamic = notesBox.values.toList();
      List<NoteHive> contacts = contactsDynamic.cast<NoteHive>();
      for (NoteHive contact in contacts) {
        // Check if the subject already exists in the database
        bool subjectExists = await checkNoteExists(contact, databaseInfo);
        if (subjectExists) {
          print('Note already exists: ${contact.subject}');
          continue;
        }

        // Prepare data to add contact
        Map<String, dynamic> postData = {
          'id': contact.id,
          'subject': contact.subject,
          'assign_ID': assignId,
          'related_ID': relatedId,
          'related_to_type': contact.relatedTo,
          'description' : contact.description,
          'created_at': DateTime.now().toIso8601String(),
        };

        String jsonData = jsonEncode(postData);
        String databaseInfoQuery = '';
        databaseInfo.forEach((key, value) {
          databaseInfoQuery += '&$key=$value';
        });

        String finalUrl = '$apiUrl?$databaseInfoQuery';
        print(finalUrl);
        http.Response response = await http.post(
          Uri.parse(finalUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonData,
        );
        print(jsonData);

        if (response.statusCode == 200) {
          print('Note added successfully: ${contact.id}');
        } else {
          print('Failed to add Note ${contact.id}. Error: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  Future<bool> checkNoteExists(NoteHive note, Map<String, dynamic>? databaseInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? '';
    String idQueryParam = id.isNotEmpty ? 'id=$id&' : '';
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found in SharedPreferences');
    }

    String apiUrl = getNotes;
    String subject = note.subject ?? '';
    print(apiUrl);

    try {
      if (databaseInfo == null) {
        throw Exception('Database info not available');
      }

      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });

      String finalUrl = '$apiUrl?$idQueryParam$databaseInfoQuery';
      print(finalUrl);
      http.Response response = await http.get(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<
            dynamic>? data = responseData['data'];

        if (data != null) {
          for (var dbContact in data) {
            String dbSubject = dbContact['subject'] ?? '';
            if (dbSubject == subject) {
              print('Note already exists');
              return true;
            }
          }
        } else {
          print('Data is null in response body');
          return false;
        }

        print('Note does not exist');
        return false;
      } else {
        throw Exception(
            'Failed to check Note existence. Status code: ${response
                .statusCode}');
      }
    }catch (error) {
      print('Error checking Note existence: $error');
      throw error;
    }
  }

  //Add Tasks To API
  Future<void> postTasksToApi(Box<TaskHive> taskBox, Ids ids) async {
    String assignId = ids.assignId;
    String relatedId = ids.relatedId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    // String? id = prefs.getString('id');

    if (token == null) {
      print('Token not found in SharedPreferences');
      return;
    }

    String apiUrl = saveTasksUrl;
    print(apiUrl);

    try {
      Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
      if (databaseInfo == null) {
        print('Database info not found');
        return;
      }
      String companyId = databaseInfo['company_id'] ?? '';
      print(companyId);

      List<dynamic> contactsDynamic = taskBox.values.toList();
      List<TaskHive> tasks = contactsDynamic.cast<TaskHive>();
      for (TaskHive task in tasks) {
        // Check if the subject already exists in the database
        bool subjectExists = await checkTaskExists(task, databaseInfo);
        if (subjectExists) {
          print('Task already exists: ${task.subject}');
          continue;
        }
        // Prepare data to add contact
        Map<String, dynamic> postData = {
          'id': task.id,
          'subject': task.subject,
          'status': task.status,
          // 'start_date': "task.startDate",
          // 'due_date': "task.dueDate",
          'priority' : task.priority,
          'assign_ID': assignId,
          'related_ID': relatedId,
          'related_to_type': task.type,
          'contact_ID' : assignId,
          'description' : task.description,
          'created_at': DateTime.now().toIso8601String(),
        };

        String jsonData = jsonEncode(postData);
        String databaseInfoQuery = '';
        databaseInfo.forEach((key, value) {
          databaseInfoQuery += '&$key=$value';
        });

        String finalUrl = '$apiUrl?$databaseInfoQuery';
        print(finalUrl);
        http.Response response = await http.post(
          Uri.parse(finalUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonData,
        );
        print(jsonData);

        if (response.statusCode == 200) {
          print('Task added successfully: ${task.id}');
        } else {
          print('Failed to add Task ${task.id}. Error: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  Future<bool> checkTaskExists(TaskHive task, Map<String, dynamic>? databaseInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? '';
    String idQueryParam = id.isNotEmpty ? 'id=$id&' : '';
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found in SharedPreferences');
    }

    String apiUrl = getTasksUrl;
    String subject = task.subject ?? '';
    print(apiUrl);

    try {
      if (databaseInfo == null) {
        throw Exception('Database info not available');
      }

      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });

      String finalUrl = '$apiUrl?$idQueryParam$databaseInfoQuery';
      print(finalUrl);
      http.Response response = await http.get(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<
            dynamic>? data = responseData['data'];

        if (data != null) {
          for (var dbContact in data) {
            String dbSubject = dbContact['subject'] ?? '';
            if (dbSubject == subject) {
              print('Task already exists');
              return true;
            }
          }
        } else {
          print('Data is null in response body');
          return false;
        }

        print('Task does not exist');
        return false;
      } else {
        throw Exception(
            'Failed to check Task existence. Status code: ${response
                .statusCode}');
      }
    }catch (error) {
      print('Error checking Task existence: $error');
      throw error;
    }
  }

}