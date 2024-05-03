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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String id = prefs.getString('id') ?? '';
    String idQueryParam = id.isNotEmpty ? '&id=$id' : '';
    // Make an HTTP GET request to fetch leads from the API
    Map<String, dynamic>? databaseInfo = await getDatabaseInfo();
    String databaseInfoQuery = '';
    databaseInfo!.forEach((key, value) {
      databaseInfoQuery += '&$key=$value';
    });
    String apiUrl = getLeads;
    String finalUrl = '$apiUrl?_token=$token$idQueryParam$databaseInfoQuery';
    final response = await http.get(Uri.parse(finalUrl));
    print(finalUrl);

    if (response.statusCode == 200) {
      // If the request is successful, parse the JSON response
      final List<dynamic> leadsJson = jsonDecode(response.body)['data'];

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
      // If the request fails, handle the error
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
    String apiUrl = getContacts;
    String finalUrl = '$apiUrl?_token=$token$idQueryParam$databaseInfoQuery';
    final response = await http.get(Uri.parse(finalUrl));
    print(finalUrl);

    if (response.statusCode == 200) {
      // If the request is successful, parse the JSON response
      final List<dynamic> contactsJson = jsonDecode(response.body)['data'];

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
      // If the request fails, handle the error
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
      final List<dynamic> callsJson = jsonDecode(response.body)['data'];

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
    // Make an HTTP GET request to fetch opportunities from the API
    Map<String, dynamic>? databaseInfo = await getDatabaseInfo();
    String databaseInfoQuery = '';
    databaseInfo!.forEach((key, value) {
      databaseInfoQuery += '&$key=$value';
    });
    String apiUrl = getOpportunities;
    String finalUrl = '$apiUrl?_token=$token$idQueryParam$databaseInfoQuery';
    print(finalUrl);

    final response = await http.get(Uri.parse(finalUrl));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Check if 'message' key exists and is not null
      if (jsonResponse.containsKey('message') && jsonResponse['message'] != null) {
        final List<dynamic> opportunitiesJson = jsonResponse['message'];

        // Open the opportunities Hive box
        final opportunitiesBox = await Hive.openBox<OpportunityHive>('opportunity');

        // Clear existing opportunities before adding new ones
        await opportunitiesBox.clear();

        // Add each opportunity to the Hive box
        for (final opportunityJson in opportunitiesJson) {
          final opportunity = OpportunityHive.fromJson(opportunityJson);
          await opportunitiesBox.add(opportunity);
        }
      } else {
        // Handle the case where 'message' is missing or null
        print('No data found in the API response');
      }
    } else {
      // Handle the case where the API request fails
      print('API request failed: ${response.body}');
      throw Exception('Failed to fetch opportunities from the API');
    }
  }



}