import 'package:flutter/material.dart';

import '../components/navDrawer.dart';
import '../main.dart';

class AdditionalInfoScreen extends StatefulWidget {
  AdditionalInfoScreen({Key? key}) : super(key: key);

  @override
  State<AdditionalInfoScreen> createState() => _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  @override
  bool themeCheckBox = false;

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navigationdrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
            Theme.of(context).brightness == Brightness.dark?'assets/White.jpeg':'assets/_Logo.png',
            height: MediaQuery.of(context).size.height*0.05
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
                title: Text('Theme'),
                leading: Icon(Icons.brightness_4_outlined),
                trailing: Switch.adaptive(
                  // activeColor: Theme.of(context).brightness == Brightness.dark
                  //     ? null
                  //     : Color(0xFFFFD966),
                  thumbColor: Theme.of(context).brightness == Brightness.dark
                      ? MaterialStateProperty.resolveWith((states) {
                    return Colors.white;
                  })
                      : MaterialStateProperty.resolveWith((states) {
                    return Color(0xFF0C76FF);
                  }),
                  value: themeCheckBox,
                  onChanged: (val) {
                    setState(() {
                      themeCheckBox = val!;
                      Theme.of(context).brightness == Brightness.dark
                          ? MyApp.of(context).changeTheme(ThemeMode.light)
                          : MyApp.of(context).changeTheme(ThemeMode.dark);
                    });
                  },
                )

            )

          ],
        ),
      ),
    );
  }
}
