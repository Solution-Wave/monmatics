import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/noteItem.dart';
import '../utils/urls.dart';
import 'importFunctions.dart';
import 'package:http/http.dart' as http;

class OtherFunctions{

  ImportFunctions importFunctions = ImportFunctions();
  // Function to update an existing note and update data in the database
  Future<void> updateNoteAndDatabase(NoteHive note, String? id) async {
    // Update data in the remote database
    Map<String, dynamic>? databaseInfo = await importFunctions.getDatabaseInfo();
    if (databaseInfo == null) {
      print('Database info not found');
      return;
    }
    try {
      // Prepare data to update note
      Map<String, dynamic> postData = {
        'id': id,
        'subject': note.subject,
        'assign_ID': note.assignTo,
        'related_ID': note.search,
        'related_to_type': note.relatedTo,
        'description': note.description,
        'updated_at': DateTime.now().toIso8601String(),
      };

      String noteId = id!;
      print(noteId);

      String jsonData = jsonEncode(postData);

      String apiUrl = updateNotes;
      String databaseInfoQuery = '';
      databaseInfo.forEach((key, value) {
        databaseInfoQuery += '&$key=$value';
      });

      String finalUrl = '$apiUrl?id=$noteId$databaseInfoQuery';
      print(finalUrl);
      // Perform HTTP request to update note in the API
      http.Response response = await http.put(
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

}