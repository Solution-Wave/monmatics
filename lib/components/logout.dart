import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:monmatics/Functions/exportFunctions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/noteItem.dart';
import '../models/taskItem.dart';
import '../screens/loginScreen.dart';
import '../utils/colors.dart';
import '../utils/messages.dart';

bool logOutLoader = false;
bool _isChecked = false;
String? assignId;
String? relatedId;

ExportFunctions exportFunctions = ExportFunctions();

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
                  Hive.openBox<NoteHive>("notes").then((notesBox) {
                    exportFunctions.postNotesToApi(notesBox, Ids(assignId!, relatedId!));
                  });
                  Hive.openBox<TaskHive>("tasks").then((tasksBox) {
                    exportFunctions.postTasksToApi(tasksBox, Ids(assignId!, relatedId!));
                  });
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
