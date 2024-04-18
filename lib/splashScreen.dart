import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/bottomNavigationBarScreen.dart';
import 'screens/firstScreen.dart';
import 'screens/loginScreen.dart';
import 'utils/urls.dart';


class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  String? selectedUrl;
  String baseUrl = '';

  Future<void> loadSelectedUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedUrl = prefs.getString('selectedUrl') ?? '';
      baseUrl = selectedUrl ?? '';
      updateUrls(baseUrl);
    });
  }

  void checkSession()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token == null) {
      Timer(const Duration(seconds: 2),()=>Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) =>
              LoginScreen()
          )
      ));
    } else
      {
        await loadSelectedUrl();
        Timer(const Duration(seconds: 2),
                ()=>Navigator.pushReplacement(context,
                    MaterialPageRoute(builder:
                        (context) =>
                             App() //first screen
                    )
                )
        );
      }
    }

  @override
  void initState() {
    super.initState();
    checkSession();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Image(
        image: const AssetImage('assets/_Logo.png'),
        height: MediaQuery.of(context).size.height * 0.2,
        //width: MediaQuery.of(context).size.width * 0.1,
      ),
    );
  }
}
