import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Functions/exportFunctions.dart';
import '../models/callItem.dart';
import '../models/contactItem.dart';
import '../models/customerItem.dart';
import '../models/leadItem.dart';
import '../models/noteItem.dart';
import '../models/opportunityItem.dart';
import '../models/taskItem.dart';
import '../models/userItem.dart';
import '../screens/loginScreen.dart';
import '../utils/colors.dart';
import '../utils/messages.dart';

bool logOutLoader = false;
bool _isChecked = false;
String? assignId;
String? relatedId;

ExportFunctions exportFunctions = ExportFunctions();

Future<void> clearHiveData()async{
  final customersBox = await Hive.openBox<CustomerHive>('customers');
  final leadsBox = await Hive.openBox<LeadHive>('leads');
  final contactsBox = await Hive.openBox<ContactHive>('contacts');
  final usersBox = await Hive.openBox<UsersHive>('users');
  final opportunityBox = await Hive.openBox<OpportunityHive>('opportunity');
  final callBox = await Hive.openBox<CallHive>('calls');

  await customersBox.clear();
  await leadsBox.clear();
  await contactsBox.clear();
  await usersBox.clear();
  await opportunityBox.clear();
  await callBox.clear();
  await clearHomeHiveData();
}

Future<void> clearHomeHiveData()async{
  final tasksBox = await Hive.openBox<TaskHive>('tasks');
  final notesBox = await Hive.openBox<NoteHive>('notes');

  await tasksBox.clear();
  await notesBox.clear();
}

logOut(BuildContext context) async {
  return showDialog(
    useSafeArea: true,
    barrierDismissible: false,
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, StateSetter setState) {
        return AlertDialog(
          title: const Text("Logout"),
          titleTextStyle: TextStyle(
              fontSize: 22,
             // fontFamily: font_family,
              color: primaryColor,
              fontWeight: FontWeight.w500),
          content: logOutLoader
              ? Container(
              height: MediaQuery.of(context).size.height * 0.09,
              alignment: Alignment.center,
              child:  CircularProgressIndicator(color: primaryColor,))
              : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isChecked = newValue!;
                      });
                    },
                  ),
                  const Text('Save Data'),
                ],
              ),
          contentTextStyle: TextStyle(
            color: primaryColor,
              fontSize: 16,),
          actions: [
            logOutLoader
                ? const Text("")
                : TextButton(
              onPressed: () {
                if(_isChecked){
                  print("Good");
                }
                setState(() {
                  _isChecked = false;
                });
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6)),
                width: MediaQuery.of(context).size.width * 0.18,
                child: Text(
                  "No",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: drawerTextCol,
                      // fontFamily: font_family,
                      fontSize: 16),
                ),
              ),
            ),
            logOutLoader
                ? const Text("")
                : TextButton(
              onPressed: () async {
                if(_isChecked){
                  exportFunctions.postCustomerToApi();
                  exportFunctions.postContactsToApi();
                  Hive.openBox<TaskHive>("tasks").then((tasksBox) {
                    exportFunctions.postTasksToApi(tasksBox);
                  });
                  Hive.openBox<NoteHive>("notes").then((notesBox) {
                    exportFunctions.postNotesToApi(notesBox);
                  });
                  exportFunctions.postLeadToApi();
                  exportFunctions.postCallsToApi();
                  exportFunctions.postOpportunityToApi();
                  await clearHiveData();
                } else{
                  print('Not Exported');
                  clearHiveData();
                }
                setState(() {
                  logOutLoader = true;
                });
                SharedPreferences prefs =
                await SharedPreferences.getInstance();
                await prefs.clear();
                Timer.periodic(const Duration(seconds: 4), (t) {
                  t.cancel();
                  Navigator.pop(context);
                  setState(() {
                    logOutLoader = false;
                  });
                  showSnackMessage(context, "Logout successfully");
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);

                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6)),
                width: MediaQuery.of(context).size.width * 0.18,
                child: Text(
                  "Yes",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                       color: drawerTextCol,
                      // fontFamily: font_family,
                      fontSize: 16),
                ),
              ),
            )
          ],
        );
      },
    ),
  );
}
