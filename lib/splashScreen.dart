import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/firstScreen.dart';
import 'screens/loginScreen.dart';


class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

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
