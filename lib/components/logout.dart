import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/loginScreen.dart';
import '../utils/colors.dart';
import '../utils/messages.dart';

bool logOutLoader = false;

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
              : const Text("Are you sure to logout"),
          contentTextStyle: TextStyle(
            color: primaryColor,
              fontSize: 16,),
          actions: [
            logOutLoader
                ? const Text("")
                : TextButton(
              onPressed: () {
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
