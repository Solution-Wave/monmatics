import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/callItem.dart';
import '../models/contactItem.dart';
import '../models/customerItem.dart';
import '../models/leadItem.dart';
import '../models/noteItem.dart';
import '../models/opportunityItem.dart';
import '../models/taskItem.dart';
import '../utils/urls.dart';
import 'exportFunctions.dart';
import 'importFunctions.dart';
import 'package:http/http.dart' as http;

class OtherFunctions{

  ImportFunctions importFunctions = ImportFunctions();

  // Function to update an existing note and update data in the database
  Future<void> updateNoteInDatabase(NoteHive note) async {
    // Update data in the remote database
    Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
    if (databaseInfo == null) {
      print('Database info not found');
      return;
    }
    try {
      // Prepare data to update note
      Map<String, dynamic> postData = {
        'id': note.id,
        'subject': note.subject,
        'assign_ID': note.assignId,
        'related_ID': note.relatedId,
        'related_to_type': note.relatedTo,
        'description': note.description,
        'updated_at': DateTime.now().toIso8601String(),
      };

      String noteId = note.id;
      print(noteId);

      String jsonData = jsonEncode(postData);

      String apiUrl = saveUpdateNotes;
      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });

      String finalUrl = '$apiUrl?id=$noteId$databaseInfoQuery';
      print(finalUrl);
      // Perform HTTP request to update note in the API
      http.Response response = await http.post(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        // Successful update
      } else {
        // Update failed
        print('Failed to update note ${note.id}. Error: ${response.statusCode}');
        // You can handle error scenario here
      }
    } catch (error) {
      // Exception occurred
      print('Error: $error');
      // You can handle error scenario here
    }
  }

// Function to update an existing note and update data in the database
  Future<void> updateTaskInDatabase(TaskHive task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    // Update data in the remote database
    Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
    if (databaseInfo == null) {
      print('Database info not found');
      return;
    }
    String companyId = databaseInfo['company_id'] ?? '';
    try {
      // Prepare data to update note
      Map<String, dynamic> postData = {
        'id': task.id,
        'subject': task.subject,
        'status': task.status,
        'start_date': task.startDate,
        'due_date': task.dueDate,
        'priority' : task.priority,
        'assigned_to': task.assignId,
        'related_id': task.relatedId,
        'related_to_type': task.type,
        'contact_id' : task.assignId,
        'description' : task.description,
        'companyId' : companyId,
        'created_by' : userId,
        'created_at': DateTime.now().toIso8601String(),
      };

      String taskId = task.id;
      print(taskId);

      String jsonData = jsonEncode(postData);

      String apiUrl = saveUpdateTasks;
      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });

      String finalUrl = '$apiUrl?id=$taskId$databaseInfoQuery';
      print(finalUrl);
      // Perform HTTP request to update note in the API
      http.Response response = await http.post(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        // Successful update
      } else {
        // Update failed
        print('Failed to update note ${task.id}. Error: ${response.statusCode}');
        // You can handle error scenario here
      }
    } catch (error) {
      // Exception occurred
      print('Error: $error');
      // You can handle error scenario here
    }
  }

  Future<void> deleteNoteFromDatabase(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found in SharedPreferences');
      }

      Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
      if (databaseInfo == null) {
        print('Database info not found');
        return;
      }

      String apiUrl = deleteNotes;
      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });
      String finalUrl = '$apiUrl?id=$id$databaseInfoQuery';
      print(finalUrl);

      final response = await http.delete(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Note deleted successfully from the database');
      } else {
        throw Exception('Failed to delete note from the database. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting note from database: $error');
      throw error;
    }
  }

  Future<void> deleteTaskFromDatabase(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found in SharedPreferences');
      }

      Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
      if (databaseInfo == null) {
        print('Database info not found');
        return;
      }

      String apiUrl = deleteTasks;
      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });
      String finalUrl = '$apiUrl?id=$id$databaseInfoQuery';
      print(finalUrl);

      final response = await http.delete(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Task deleted successfully from the database');
      } else {
        throw Exception('Failed to delete Task from the database. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting Task from database: $error');
      throw error;
    }
  }

  // Function to update an existing call and update data in the database
  Future<void> updateCallInDatabase(CallHive call) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    // Update data in the remote database
    Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
    if (databaseInfo == null) {
      print('Database info not found');
      return;
    }
    String companyId = databaseInfo['company_id'] ?? '';
    print(companyId);
    final inputFormat = DateFormat('yyyy-MM-dd h:mm a');
    final outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime dateTime = inputFormat.parse('${call.startDate} ${call.startTime}');
    String startDateTime = outputFormat.format(dateTime);
    try {
      // Prepare data to update note
      Map<String, dynamic> postData = {
        'id': call.id,
        'subject': call.subject,
        'status': call.status,
        'start_date': startDateTime,
        'end_date': call.endDate,
        'assigned_to': call.assignId,
        'related_id': call.relatedId,
        'related_to_type': call.relatedType,
        'contact_id' : call.contactId,
        'description' : call.description,
        'communication_type' : call.communicationType,
        'created_by' : userId,
        'companyId' : companyId,
        'created_at': DateTime.now().toIso8601String(),
      };

      String callId = call.id;
      print(callId);

      String jsonData = jsonEncode(postData);

      String apiUrl = saveUpdateCalls;
      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });

      String finalUrl = '$apiUrl?id=$callId$databaseInfoQuery';
      print(finalUrl);
      // Perform HTTP request to update note in the API
      http.Response response = await http.post(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        // Successful update
      } else {
        // Update failed
        print('Failed to update Call ${call.id}. Error: ${response.statusCode}');
        // You can handle error scenario here
      }
    } catch (error) {
      // Exception occurred
      print('Error: $error');
      // You can handle error scenario here
    }
  }

  Future<void> deleteCallFromDatabase(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found in SharedPreferences');
      }

      Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
      if (databaseInfo == null) {
        print('Database info not found');
        return;
      }

      String apiUrl = deleteCalls;
      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });
      String finalUrl = '$apiUrl?id=$id$databaseInfoQuery';
      print(finalUrl);

      final response = await http.delete(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Call deleted successfully from the database');
      } else {
        throw Exception('Failed to delete Call from the database. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting Call from database: $error');
      throw error;
    }
  }

  // Function to update an existing Opportunity and update data in the database
  Future<void> updateOpportunityInDatabase(OpportunityHive opportunity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    // Update data in the remote database
    Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
    if (databaseInfo == null) {
      print('Database info not found');
      return;
    }
    String companyId = databaseInfo['company_id'] ?? '';
    print(companyId);
    try {
      // Prepare data to update Opportunity
      Map<String, dynamic> postData = {
        'id': opportunity.id,
        'name': opportunity.name,
        'cust_id': opportunity.leadId,
        'cur_name': opportunity.currency,
        'amount': opportunity.amount,
        'close_date': opportunity.closeDate,
        'lead_type': opportunity.type,
        'sale_stage': opportunity.stage,
        'lead_source': opportunity.source,
        'compaign_id': opportunity.campaign,
        'next_step': opportunity.nextStep,
        'assigned_to': opportunity.assignId,
        'description': opportunity.description,
        'created_by' : userId,
        'created_at': DateTime.now().toIso8601String(),
        // Add other necessary fields here
      };

      String opportunityId = opportunity.id;
      print(opportunityId);

      String jsonData = jsonEncode(postData);

      String apiUrl = saveUpdateOpportunity;
      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });

      String finalUrl = '$apiUrl?id=$opportunityId$databaseInfoQuery';
      print(finalUrl);
      // Perform HTTP request to update oportunity in the API
      http.Response response = await http.post(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        // Successful update
      } else {
        // Update failed
        print('Failed to update Opportunity ${opportunity.id}. Error: ${response.statusCode}');
        // You can handle error scenario here
      }
    } catch (error) {
      // Exception occurred
      print('Error: $error');
      // You can handle error scenario here
    }
  }

  // Function to update an existing Customer and update data in the database
  Future<void> updateCustomerInDatabase(CustomerHive customer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    // Update data in the remote database
    Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
    if (databaseInfo == null) {
      print('Database info not found');
      return;
    }
    String companyId = databaseInfo['company_id'] ?? '';
    print(companyId);
    try {
      // Prepare data to update Customer
      Map<String, dynamic> postData = {
        'id' : customer.id,
        'type': customer.type,
        'name': customer.name,
        'tax_number' : customer.taxNumber,
        'category' : customer.category,
        'note' : customer.note,
        'status' : customer.status,
        'assigned_to' : userId,
        'credit_limit' : customer.limit,
        'credit_amount' : customer.amount,
        'margin' : customer.margin,
        'lead' : "",
        'lead_source' : '',
        'companyId': companyId,
        "created_by" : userId,
        'created_at': DateTime.now().toIso8601String(),
      };

      String customerId = customer.id;
      print(customerId);

      String jsonData = jsonEncode(postData);

      String apiUrl = saveUpdateCustomers;
      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });

      String finalUrl = '$apiUrl?id=$customerId$databaseInfoQuery';
      print(finalUrl);
      // Perform HTTP request to update Customer in the API
      http.Response response = await http.post(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        // Successful update
      } else {
        // Update failed
        print('Failed to update Customer ${customer.id}. Error: ${response.statusCode}');
        // You can handle error scenario here
      }
    } catch (error) {
      // Exception occurred
      print('Error: $error');
      // You can handle error scenario here
    }
  }

  // Function to update an existing Lead and update data in the database
  Future<void> updateLeadInDatabase(LeadHive lead) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    // Update data in the remote database
    Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
    if (databaseInfo == null) {
      print('Database info not found');
      return;
    }
    String companyId = databaseInfo['company_id'] ?? '';
    print(companyId);
    try {
      // Prepare data to update Lead
      Map<String, dynamic> postData = {
        'id': lead.id,
        'type': lead.type,
        'name': lead.name,
        'lead' : userId,
        'companyId': companyId,
        // 'userId': userId,
        'status': lead.status,
        'category' : lead.category,
        'note' : lead.note,
        'created_by' : userId,
        'lead_source' : lead.leadSource,
        'assigned_to' : userId,
        'email' : lead.email,
        'phone' : lead.phone,
        'address' : lead.address,
        'created_at': DateTime.now().toIso8601String(),
      };

      String leadId = lead.id;
      print(leadId);

      String jsonData = jsonEncode(postData);

      String apiUrl = saveUpdateLeads;
      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });

      String finalUrl = '$apiUrl?id=$leadId$databaseInfoQuery';
      print(finalUrl);
      // Perform HTTP request to update Lead in the API
      http.Response response = await http.post(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        // Successful update
      } else {
        // Update failed
        print('Failed to update Lead ${lead.id}. Error: ${response.statusCode}');
        // You can handle error scenario here
      }
    } catch (error) {
      // Exception occurred
      print('Error: $error');
      // You can handle error scenario here
    }
  }

  // Function to update an existing contact and update data in the database
  Future<void> updateContactInDatabase(ContactHive contact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    // Update data in the remote database
    Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
    if (databaseInfo == null) {
      print('Database info not found');
      return;
    }
    String companyId = databaseInfo['company_id'] ?? '';
    print(companyId);
    try {
      // Prepare data to update contact
      Map<String, dynamic> postData = {
        'id' : contact.id,
        'type': contact.type,
        'fname': contact.fName,
        'lname': contact.lName,
        'title': contact.title,
        'related_to_type': contact.relatedTo,
        'related_ID': contact.search,
        'assigned_to': contact.assignTo,
        'mobile': contact.phone,
        'email': contact.email,
        'phone_office': contact.officePhone,
        'companyId': companyId,
        // 'user_id': userId,
        'created_by' : userId,
        'address' : contact.address,
        'city' : contact.city,
        'state' : contact.state,
        'postal_code' : contact.postalCode,
        'country' : contact.country,
        'description' : contact.description,
        'created_at': DateTime.now().toIso8601String(),
      };

      String contactId = contact.id;
      print(contactId);

      String jsonData = jsonEncode(postData);

      String apiUrl = saveUpdateContacts;
      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });

      String finalUrl = '$apiUrl?id=$contactId$databaseInfoQuery';
      print(finalUrl);
      // Perform HTTP request to update contact in the API
      http.Response response = await http.post(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        // Successful update
      } else {
        // Update failed
        print('Failed to update contact ${contact.id}. Error: ${response.statusCode}');
        // You can handle error scenario here
      }
    } catch (error) {
      // Exception occurred
      print('Error: $error');
      // You can handle error scenario here
    }
  }

}