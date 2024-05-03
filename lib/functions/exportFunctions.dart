import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../models/contactItem.dart';
import '../../models/customerItem.dart';
import '../../models/leadItem.dart';
import '../../models/noteItem.dart';
import '../../models/taskItem.dart';
import '../../utils/urls.dart';
import '../models/callItem.dart';
import '../models/opportunityItem.dart';
import 'importFunctions.dart';
import 'searchFunctions.dart';

class ExportFunctions {

  ImportFunctions importFunctions = ImportFunctions();

  // Add lead To API
  Future<void> postLeadToApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userId = prefs.getString('id');

    if (token == null) {
      print('Token not found in SharedPreferences');
      return;
    }

    String apiUrl = saveUpdateLeads;
    print(apiUrl);
    print(userId);

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

      leads.sort((a, b) {
        DateTime? addedAtA = a.addedAt;
        DateTime? addedAtB = b.addedAt;

        if (addedAtA == null) {
          return 1; // Move 'a' to the end if 'addedAt' is null
        } else if (addedAtB == null) {
          return -1; // Move 'b' to the end if 'addedAt' is null
        } else {
          return addedAtB.compareTo(addedAtA);
        }
      });

      for (LeadHive lead in leads) {
        // Check if lead already exists before attempting to add
        // bool leadExists = await checkLeadExists(lead, databaseInfo);
        // if (leadExists) {
        //   print('Lead already exists: ${lead.name}');
        //   continue;
        // }

        // Prepare data to add lead
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
        print(finalUrl);

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

  // Add customer To API
  Future<void> postCustomerToApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    String? token = prefs.getString('token');


    String apiUrl = saveUpdateCustomers;

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

      customers.sort((a, b) {
        DateTime? addedAtA = a.addedAt;
        DateTime? addedAtB = b.addedAt;

        if (addedAtA == null) {
          return 1; // Move 'a' to the end if 'addedAt' is null
        } else if (addedAtB == null) {
          return -1; // Move 'b' to the end if 'addedAt' is null
        } else {
          return addedAtB.compareTo(addedAtA);
        }
      });

      for (CustomerHive customer in customers) {
        // Check if customer already exists before attempting to add
        // bool customerExists = await checkCustomerExists(customer, databaseInfo);
        // if (customerExists) {
        //   print('Customer already exists: ${customer.name}');
        //   continue;
        // }

        // Prepare data to add customer
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
        print(finalUrl);

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

  // Add Contact To API
  Future<void> postContactsToApi() async {
    // Retrieve token and other required information
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userId = prefs.getString('id');

    if (token == null) {
      print('Token not found in SharedPreferences');
      return;
    }

    // Retrieve the API URL and company ID
    String apiUrl = saveUpdateContacts;
    Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
    if (databaseInfo == null) {
      print('Database info not found');
      return;
    }

    String companyId = databaseInfo['company_id'] ?? '';

    // Open Hive box and retrieve contacts
    Box<ContactHive>? contactBox = await Hive.openBox<ContactHive>("contacts");
    List<ContactHive> contacts = contactBox.values.toList().cast<ContactHive>();

    // Sort contacts by addedAt in descending order (newest first)
    contacts.sort((a, b) {
      DateTime? addedAtA = a.addedAt;
      DateTime? addedAtB = b.addedAt;

      if (addedAtA == null) {
        return 1; // Move 'a' to the end if 'addedAt' is null
      } else if (addedAtB == null) {
        return -1; // Move 'b' to the end if 'addedAt' is null
      } else {
        return addedAtB.compareTo(addedAtA);
      }
    });


    // Upload contacts to the API
    for (ContactHive contact in contacts) {
      print('${contact.addedAt}: ${contact.fName} ${contact.lName}');
      // Prepare data for the API request
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

      // Convert data to JSON
      String jsonData = jsonEncode(postData);
      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) => databaseInfoQuery += '&$key=$value');

      // Construct the API request URL
      String finalUrl = '$apiUrl?_token=$token$databaseInfoQuery';

      // Make the API request
      http.Response response = await http.post(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );
      print(finalUrl);

      // Handle the API response
      if (response.statusCode == 200) {
        print('Contact added successfully: ${contact.fName} ${contact.lName}');
      } else {
        print('Failed to add contact ${contact.fName} ${contact.lName}. Error: ${response.statusCode}');
      }
    }
  }

  // Add Notes To API
  Future<void> postNotesToApi(Box<NoteHive> notesBox) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userId = prefs.getString('id');

    if (token == null) {
      print('Token not found in SharedPreferences');
      return;
    }

    String apiUrl = saveUpdateNotes;

    try {
      Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
      if (databaseInfo == null) {
        print('Database info not found');
        return;
      }
      String companyId = databaseInfo['company_id'] ?? '';
      print(companyId);
      List<dynamic> notesDynamic = notesBox.values.toList();
      List<NoteHive> notes = notesDynamic.cast<NoteHive>();

      notes.sort((a, b) {
        DateTime? addedAtA = a.addedAt;
        DateTime? addedAtB = b.addedAt;

        if (addedAtA == null) {
          return 1; // Move 'a' to the end if 'addedAt' is null
        } else if (addedAtB == null) {
          return -1; // Move 'b' to the end if 'addedAt' is null
        } else {
          return addedAtB.compareTo(addedAtA);
        }
      });

      for (NoteHive note in notes) {
        // Check if the subject already exists in the database
        // bool subjectExists = await checkNoteExists(contact, databaseInfo);
        // if (subjectExists) {
        //   print('Note already exists: ${contact.subject}');
        //   continue;
        // }

        // Prepare data to add contact
        Map<String, dynamic> postData = {
          'id': note.id,
          'subject': note.subject,
          'assign_ID': note.assignId,
          'related_ID': note.relatedId,
          'related_to_type': note.relatedTo,
          'description' : note.description,
          'created_at': DateTime.now().toIso8601String(),
        };

        String jsonData = jsonEncode(postData);
        String databaseInfoQuery = '';
        databaseInfo.forEach((key, value) {
          databaseInfoQuery += '&$key=$value';
        });

        String finalUrl = '$apiUrl?_token=$token$databaseInfoQuery';
        print(finalUrl);
        http.Response response = await http.post(
          Uri.parse(finalUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonData,
        );
        print(finalUrl);

        if (response.statusCode == 200) {
          print('Note added successfully: ${note.id}');
        } else {
          print('Failed to add Note ${note.id}. Error: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  //Add Tasks To API
  Future<void> postTasksToApi(Box<TaskHive> taskBox) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userid = prefs.getString('id');

    if (token == null) {
      print('Token not found in SharedPreferences');
      return;
    }

    String apiUrl = saveUpdateTasks;

    try {
      Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
      if (databaseInfo == null) {
        print('Database info not found');
        return;
      }
      String companyId = databaseInfo['company_id'] ?? '';
      print(companyId);

      List<dynamic> tasksDynamic = taskBox.values.toList();
      List<TaskHive> tasks = tasksDynamic.cast<TaskHive>();

      tasks.sort((a, b) {
        DateTime? addedAtA = a.addedAt;
        DateTime? addedAtB = b.addedAt;

        if (addedAtA == null) {
          return 1; // Move 'a' to the end if 'addedAt' is null
        } else if (addedAtB == null) {
          return -1; // Move 'b' to the end if 'addedAt' is null
        } else {
          return addedAtB.compareTo(addedAtA);
        }
      });

      for (TaskHive task in tasks) {
        print(task.addedAt);
        // Check if the subject already exists in the database
        // bool subjectExists = await checkTaskExists(task, databaseInfo);
        // if (subjectExists) {
        //   print('Task already exists: ${task.subject}');
        //   continue;
        // }

        // Prepare data to add contact
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
          'created_by' : userid,
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
        print(finalUrl);

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

  //Add Calls To API
  Future<void> postCallsToApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    String? token = prefs.getString('token');
    String apiUrl = saveUpdateCalls;

    try {
      Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
      if (databaseInfo == null) {
        print('Database info not found');
        return;
      }
      String companyId = databaseInfo['company_id'] ?? '';
      print(companyId);

      // Open Hive box
      Box? callBox = await Hive.openBox<CallHive>("calls");
      List<dynamic> callsDynamic = callBox.values.toList();
      List<CallHive> calls = callsDynamic.cast<CallHive>();

      calls.sort((a, b) {
        DateTime? addedAtA = a.addedAt;
        DateTime? addedAtB = b.addedAt;

        if (addedAtA == null) {
          return 1;
        } else if (addedAtB == null) {
          return -1;
        } else {
          return addedAtB.compareTo(addedAtA);
        }
      });

      for (CallHive call in calls) {
        // Convert the date and time to the desired format
        // DateFormat inputFormat = DateFormat("yyyy-MM-dd h:mm a");
        DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

        // Parse the input date and time
        DateTime startDateTime = outputFormat.parse("${call.startDate} ${call.startTime}");
        DateTime endDateTime = outputFormat.parse("${call.endDate} ${call.endTime}");

        // Format the date and time in the desired format
        String startDate = outputFormat.format(startDateTime);
        String endDate = outputFormat.format(endDateTime);

        // Prepare data to add contact
        Map<String, dynamic> postData = {
          'id': call.id,
          'subject': call.subject,
          'status': call.status,
          'start_date': startDate,
          'end_date': endDate,
          'assigned_to': call.assignId,
          'related_id': call.relatedId,
          'related_to_type': call.relatedType,
          'contact_id': call.contactId,
          'description': call.description,
          'created_by': userId,
          'communication_type': call.communicationType,
          'companyId': companyId,
          'created_at': DateTime.now().toIso8601String(),
        };

        String jsonData = jsonEncode(postData);
        String databaseInfoQuery = '';
        databaseInfo.forEach((key, value) {
          databaseInfoQuery += '&$key=$value';
        });

        String finalUrl = '$apiUrl?_token=$token$databaseInfoQuery';
        print("${call.addedAt}");
        http.Response response = await http.post(
          Uri.parse(finalUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonData,
        );
        print(finalUrl);

        if (response.statusCode == 200) {
          print('Call added successfully: ${call.id}');
        } else {
          print('Failed to add Call ${call.id}. Error: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  // Future<bool> checkCallExists(CallHive call, Map<String, dynamic>? databaseInfo) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String id = prefs.getString('id') ?? '';
  //   String idQueryParam = id.isNotEmpty ? 'id=$id&' : '';
  //   String? token = prefs.getString('token');
  //   if (token == null) {
  //     throw Exception('Token not found in SharedPreferences');
  //   }
  //
  //   String apiUrl = getCallsUrl;
  //   String subject = call.subject ?? '';
  //   print(apiUrl);
  //
  //   try {
  //     if (databaseInfo == null) {
  //       throw Exception('Database info not available');
  //     }
  //
  //     String databaseInfoQuery = '';
  //     databaseInfo.forEach((key, value) {
  //       databaseInfoQuery += '&$key=$value';
  //     });
  //
  //     String finalUrl = '$apiUrl?$idQueryParam$databaseInfoQuery';
  //     print(finalUrl);
  //     http.Response response = await http.get(
  //       Uri.parse(finalUrl),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // Parse the response body
  //       Map<String, dynamic> responseData = jsonDecode(response.body);
  //       List<
  //           dynamic>? data = responseData['data'];
  //
  //       if (data != null) {
  //         for (var dbContact in data) {
  //           String dbSubject = dbContact['subject'] ?? '';
  //           if (dbSubject == subject) {
  //             print('Call already exists');
  //             return true;
  //           }
  //         }
  //       } else {
  //         print('Data is null in response body');
  //         return false;
  //       }
  //
  //       print('Call does not exist');
  //       return false;
  //     } else {
  //       throw Exception(
  //           'Failed to check Task existence. Status code: ${response
  //               .statusCode}');
  //     }
  //   }catch (error) {
  //     print('Error checking Task existence: $error');
  //     throw error;
  //   }
  // }

  Future<void> postOpportunityToApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userId = prefs.getString('id');

    if (token == null) {
      print('Token not found in SharedPreferences');
      return;
    }

    String apiUrl = saveUpdateOpportunity;

    try {
      Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
      if (databaseInfo == null) {
        print('Database info not found');
        return;
      }
      String companyId = databaseInfo['company_id'] ?? '';
      print(companyId);

      // Open Hive box
      Box? opportunityBox = await Hive.openBox<OpportunityHive>("opportunity");

      List<dynamic> opportunityDynamic = opportunityBox.values.toList();
      List<OpportunityHive> opportunities = opportunityDynamic.cast<OpportunityHive>();

      opportunities.sort((a, b) {
        DateTime? addedAtA = a.addedAt;
        DateTime? addedAtB = b.addedAt;

        if (addedAtA == null) {
          return 1; // Move 'a' to the end if 'addedAt' is null
        } else if (addedAtB == null) {
          return -1; // Move 'b' to the end if 'addedAt' is null
        } else {
          return addedAtB.compareTo(addedAtA);
        }
      });

      for (OpportunityHive opportunity in opportunities) {
        // Check if the subject already exists in the database
        // bool subjectExists = await checkCallExists(call, databaseInfo);
        // if (subjectExists) {
        //   print('Call already exists: ${call.subject}');
        //   continue;
        // }

        // Prepare data to add contact
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


        String jsonData = jsonEncode(postData);
        String databaseInfoQuery = '';
        databaseInfo.forEach((key, value) {
          databaseInfoQuery += '&$key=$value';
        });

        String finalUrl = '$apiUrl?_token=$token$databaseInfoQuery';
        print(finalUrl);
        http.Response response = await http.post(
          Uri.parse(finalUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonData,
        );
        print(finalUrl);

        if (response.statusCode == 200) {
          print('Opportunity added successfully: ${opportunity.name}');
        } else {
          print('Failed to add Opportunity ${opportunity.id}. Error: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }

}