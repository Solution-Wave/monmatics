import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/navDrawer.dart';
import '../utils/theme_provider.dart';

class AdditionalInfoScreen extends StatefulWidget {
  AdditionalInfoScreen({Key? key}) : super(key: key);

  @override
  _AdditionalInfoScreenState createState() => _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the ThemeProvider and check if the theme is dark
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkTheme = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      drawer: navigationdrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          isDarkTheme ? 'assets/White.jpeg' : 'assets/_Logo.png',
          height: MediaQuery.of(context).size.height * 0.05,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('Theme'),
              leading: const Icon(Icons.brightness_4_outlined),
              trailing: Switch.adaptive(
                thumbColor: isDarkTheme
                    ? MaterialStateProperty.resolveWith((states) => Colors.white)
                    : MaterialStateProperty.resolveWith((states) => const Color(0xFF0C76FF)),
                value: isDarkTheme,
                onChanged: (val) {
                  themeProvider.switchTheme(); // Switch the theme using ThemeProvider
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
