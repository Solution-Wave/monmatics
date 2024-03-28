import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'splashScreen.dart';
import 'utils/colors.dart';
import 'utils/themes.dart';
import 'utils/urlprovider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  // Initialize hive
  await Hive.initFlutter();
  runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) =>const MyApp()
  // ),
    ChangeNotifierProvider(
      create: (_) => UrlProvider(), // Provide the UrlProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context)=> context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  /// 1) our themeMode "state" field
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      // title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: monmaticsAppBar,
        useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: primaryColor
          )
      ),
      darkTheme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          surface: bgColorForDarkThemeWidgets,

        ),

      ),
      themeMode: _themeMode, // 2) ← ← ← use "state" field here //////////////
      home: const splashScreen(),
    );
  }

  /// 3) Call this to change theme from any context using "of" accessor
  /// e.g.:
  // / MyApp.of(context).changeTheme(ThemeMode.dark);
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}

