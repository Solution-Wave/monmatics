import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../models/contactItem.dart';
import '../../models/customerItem.dart';
import '../../models/leadItem.dart';
import '../../models/noteItem.dart';
import '../../models/taskItem.dart';
import '../../models/userItem.dart';
import '../../utils/urls.dart';
import '../models/callItem.dart';
import '../models/opportunityItem.dart';

class ImportFunctions{

  // Get DataBase Info
  Future<Map<String, dynamic>?> getDatabaseInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? databaseInfoJson = prefs.getString('database_info');

    if (databaseInfoJson != null) {
      Map<String, dynamic> databaseInfo = jsonDecode(databaseInfoJson);
      print(databaseInfo);
      return databaseInfo;
    } else {
      print("No DataBase Exist");
      return null;
    }
  }

  // Leads Fetch Function
  Future<void> fetchLeadsFromApi() async {
    // Get SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String id = prefs.getString('id') ?? '';
    String idQueryParam = id.isNotEmpty ? '&id=$id' : '';

    // Retrieve database info and construct query parameters
    Map<String, dynamic>? databaseInfo = await getDatabaseInfo();
    String databaseInfoQuery = '';
    if (databaseInfo != null) {
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });
    }

    // Construct the final URL for the API request
    String apiUrl = getLeads;
    String finalUrl = '$apiUrl?_token=$token$idQueryParam$databaseInfoQuery';
    print(finalUrl);

    // Make the API request
    final response = await http.get(Uri.parse(finalUrl));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Check if 'data' key exists and is a list
      if (jsonResponse.containsKey('data') && jsonResponse['data'] is List) {
        final List<dynamic> leadsJson = jsonResponse['data'];

        // Open the leads Hive box
        final leadsBox = await Hive.openBox<LeadHive>('leads');

        // Clear existing leads before adding new ones
        await leadsBox.clear();

        // Add each lead to the Hive box
        for (final leadJson in leadsJson) {
          final lead = LeadHive.fromJson(leadJson);
          await leadsBox.add(lead);
        }
      } else {
        // Handle cases where 'data' key is missing or not a list
        print('API response does not contain "data" key or "data" is not a list');
      }
    } else {
      // Handle cases where the API request fails
      print('API request failed: ${response.body}');
      throw Exception('Failed to fetch leads from the API');
    }
  }


  // Customer Fetch Function
  Future<void> fetchCustomersFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String id = prefs.getString('id') ?? '';
    String idQueryParam = id.isNotEmpty ? '&userId=$id' : '';
    // Make an HTTP GET request to fetch customers from the API
    Map<String, dynamic>? databaseInfo = await getDatabaseInfo();
    String databaseInfoQuery = '';
    databaseInfo!.forEach((key, value) {
      databaseInfoQuery += '&$key=$value';
    });
    String apiUrl = getCustomer;
    String finalUrl = '$apiUrl?_token=$token$idQueryParam$databaseInfoQuery';
    final response = await http.get(Uri.parse(finalUrl));
    print(finalUrl);

    if (response.statusCode == 200) {
      // If the request is successful, parse the JSON response
      final List<dynamic> customersJson = jsonDecode(response.body)['data'];

      // Open the customers Hive box
      final customersBox = await Hive.openBox<CustomerHive>('customers');

      // Clear existing customers before adding new ones
      await customersBox.clear();

      // Add each customer to the Hive box
      for (final customerJson in customersJson) {
        final customer = CustomerHive.fromJson(customerJson);
        await customersBox.add(customer);
      }
    } else {
      // If the request fails, handle the error
      throw Exception('Failed to fetch Customers from the API');
    }
  }

  // Contacts Fetch Function
  Future<void> fetchContactsFromApi() async {
    // Retrieve SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String id = prefs.getString('id') ?? '';
    String idQueryParam = id.isNotEmpty ? '&userId=$id' : '';

    // Retrieve database info and construct query parameters
    Map<String, dynamic>? databaseInfo = await getDatabaseInfo();
    String databaseInfoQuery = '';
    if (databaseInfo != null) {
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });
    }

    // Construct the final URL for the API request
    String apiUrl = getContacts;
    String finalUrl = '$apiUrl?_token=$token$idQueryParam$databaseInfoQuery';
    print(finalUrl);

    // Make the API request
    final response = await http.get(Uri.parse(finalUrl));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Check if 'data' key exists and is a list
      if (jsonResponse.containsKey('data') && jsonResponse['data'] is List) {
        final List<dynamic> contactsJson = jsonResponse['data'];

        // Open the contacts Hive box
        final contactsBox = await Hive.openBox<ContactHive>('contacts');

        // Clear existing contacts before adding new ones
        await contactsBox.clear();

        // Add each contact to the Hive box
        for (final contactJson in contactsJson) {
          final contact = ContactHive.fromJson(contactJson);
          await contactsBox.add(contact);
        }
      } else {
        // Handle cases where 'data' key is missing or not a list
        print('API response does not contain "data" key or "data" is not a list');
      }
    } else {
      // Handle cases where the API request fails
      print('API request failed: ${response.body}');
      throw Exception('Failed to fetch contacts from the API');
    }
  }


  // Task Fetch Function
  Future<void> fetchTasksFromApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String id = prefs.getString('id') ?? '';
      String idQueryParam = id.isNotEmpty ? '&userId=$id&' : '';

      // Make an HTTP GET request to fetch Notes from the API
      Map<String, dynamic> databaseInfo = (await getDatabaseInfo()) ?? {};
      String databaseInfoQuery = databaseInfo.entries.map((entry) => '${entry.key}=${entry.value}').join('&');

      String apiUrl = getTasksUrl;
      String finalUrl = '$apiUrl?_token=$token$idQueryParam$databaseInfoQuery';

      final response = await http.get(Uri.parse(finalUrl));
      print(finalUrl);

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final dynamic responseData = jsonDecode(response.body);
        final List<dynamic> tasksJson = responseData['data'] ?? [];

        // Open the Tasks Hive box
        final taskBox = await Hive.openBox<TaskHive>('tasks');

        // Clear existing Tasks before adding new ones
        await taskBox.clear();

        // Add each Task to the Hive box
        for (final taskJson in tasksJson) {
          final tasks = TaskHive.fromJson(taskJson);
          await taskBox.add(tasks);
        }
      } else {
        // If the request fails, handle the error
        throw Exception('Failed to fetch Tasks from the API');
      }
    } catch (e) {
      print('Error fetching Tasks: $e');
      throw Exception('Failed to fetch Tasks from the API');
    }
  }

  // Notes Fetch Function
  Future<void> fetchNotesFromApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String id = prefs.getString('id') ?? '';
      String idQueryParam = id.isNotEmpty ? '&id=$id&' : '';

      // Make an HTTP GET request to fetch Notes from the API
      Map<String, dynamic> databaseInfo = (await getDatabaseInfo()) ?? {};
      String databaseInfoQuery = databaseInfo.entries.map((entry) => '${entry.key}=${entry.value}').join('&');

      String apiUrl = getNotes;
      String finalUrl = '$apiUrl?_token=$token$idQueryParam$databaseInfoQuery';

      final response = await http.get(Uri.parse(finalUrl));
      print(finalUrl);

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final dynamic responseData = jsonDecode(response.body);
        final List<dynamic> notesJson = responseData['data'] ?? [];

        // Open the Notes Hive box
        final notesBox = await Hive.openBox<NoteHive>('notes');

        // Clear existing Notes before adding new ones
        await notesBox.clear();

        // Add each note to the Hive box
        for (final noteJson in notesJson) {
          final notes = NoteHive.fromJson(noteJson);
          await notesBox.add(notes);
        }
      } else {
        // If the request fails, handle the error
        throw Exception('Failed to fetch Notes from the API');
      }
    } catch (e) {
      print('Error fetching Notes: $e');
      throw Exception('Failed to fetch Notes from the API');
    }
  }

  // Fetch Users From API and Save In Hive
  Future<void> fetchUsersFromApi() async {
    try {
      // Make an HTTP GET request to fetch Notes from the API
      Map<String, dynamic> databaseInfo = (await getDatabaseInfo()) ?? {};
      String databaseInfoQuery = databaseInfo.entries.map((entry) => '${entry.key}=${entry.value}').join('&');

      String apiUrl = getUsers;
      String finalUrl = '$apiUrl?$databaseInfoQuery';

      final response = await http.get(Uri.parse(finalUrl));
      print(finalUrl);

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final dynamic responseData = jsonDecode(response.body);
        final List<dynamic> usersJson = responseData['data'] ?? [];

        // Open the Users Hive box
        final userBox = await Hive.openBox<UsersHive>('users');

        // Clear existing Users before adding new ones
        await userBox.clear();

        // Add each Users to the Hive box
        for (final userJson in usersJson) {
          final users = UsersHive.fromJson(userJson);
          await userBox.add(users);
        }
      } else {
        // If the request fails, handle the error
        throw Exception('Failed to fetch Users from the API');
      }
    } catch (e) {
      print('Error fetching Users: $e');
      throw Exception('Failed to fetch Users from the API');
    }
  }

  // Calls Fetch Function
  Future<void> fetchCallsFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String id = prefs.getString('id') ?? '';
    String idQueryParam = id.isNotEmpty ? '&userId=$id' : '';
    // Make an HTTP GET request to fetch contacts from the API
    Map<String, dynamic>? databaseInfo = await getDatabaseInfo();
    String databaseInfoQuery = '';
    databaseInfo!.forEach((key, value) {
      databaseInfoQuery += '&$key=$value';
    });
    String apiUrl = getCallsUrl;
    String finalUrl = '$apiUrl?_token=$token$idQueryParam$databaseInfoQuery';
    final response = await http.get(Uri.parse(finalUrl));
    print(finalUrl);

    if (response.statusCode == 200) {
      // If the request is successful, parse the JSON response
      final responseData = jsonDecode(response.body);

      // Check if 'data' exists in the response and if it is a list
      if (responseData != null && responseData.containsKey('data') && responseData['data'] is List) {
        final List<dynamic> callsJson = responseData['data'];

        // Open the contacts Hive box
        final callsBox = await Hive.openBox<CallHive>('calls');

        // Clear existing contacts before adding new ones
        await callsBox.clear();

        // Add each contact to the Hive box
        for (final callJson in callsJson) {
          final call = CallHive.fromJson(callJson);
          await callsBox.add(call);
        }
      } else {
        throw Exception('Expected key "data" in the response or the data is not a list');
      }
    } else {
      // If the request fails, handle the error
      throw Exception('Failed to fetch Calls from the API');
    }
  }

  // Opportunity Fetch Function
  Future<void> fetchOpportunitiesFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String id = prefs.getString('id') ?? '';
    String idQueryParam = id.isNotEmpty ? '&userId=$id' : '';

    // Retrieve database info
    Map<String, dynamic>? databaseInfo = await getDatabaseInfo();
    String databaseInfoQuery = '';
    if (databaseInfo != null) {
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });
    }

    // Construct final URL
    String apiUrl = getOpportunities;
    String finalUrl = '$apiUrl?_token=$token$idQueryParam$databaseInfoQuery';
    print(finalUrl);

    // Make the API request
    final response = await http.get(Uri.parse(finalUrl));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Check if 'message' key exists in the JSON response
      if (jsonResponse.containsKey('message')) {
        final message = jsonResponse['message'];

        // Handle 'message' depending on its type
        if (message is List<dynamic>) {
          // Open the opportunities Hive box
          final opportunitiesBox = await Hive.openBox<OpportunityHive>('opportunity');

          // Clear existing opportunities before adding new ones
          await opportunitiesBox.clear();

          // Add each opportunity to the Hive box
          for (final opportunityJson in message) {
            final opportunity = OpportunityHive.fromJson(opportunityJson);
            await opportunitiesBox.add(opportunity);
          }
        } else if (message is String) {
          // Handle the case where 'message' is a string
          print('API response message: $message');
        } else {
          // Handle unexpected data type for 'message'
          print('Unexpected type for "message" in API response: ${message.runtimeType}');
        }
      } else {
        // Handle the case where 'message' key is missing
        print('No "message" key found in the API response');
      }
    } else {
      // Handle the case where the API request fails
      print('API request failed: ${response.body}');
      throw Exception('Failed to fetch opportunities from the API');
    }
  }

}